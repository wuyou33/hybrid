function sim_results = sim_operation(signal, cut, varargin)
% SIM_OPERATION applies control strategy for signal for specific cut
%
%   Simulation of a hybrid storage pair for a signal at a specific cut.
%
%   The dimensioning of the storages is performed via SDODE. This function
%   acts as a verification or visualization of the operational control for
%   a specific dimensioning at a specific cut. It calculates the powers of
%   base and peak over time accompanied by energy contents and a few
%   control states over time.
%
%   SIM_RESULTS = SIM_OPERATION(SIGNAL, CUT, <STRATEGY>, <OPT>) where
%   SIGNAL is a struct generated by GEN_SIGNAL. CUT defines the power cut
%   in [0..1], STRATEGY can be 'inter' (default) or 'nointer' and chooses
%   the control strategy -- 'inter' allows an inter-storage power flow,
%   'nointer' prohibits an inter-storage power flow. OPT is an options
%   structure generated by HYBRIDSET.
%
%   Important fields in OPT are 'continuous_solver', 'discrete_solver',
%   'tanh_sim', 'plot_sim'.
%
%   Examples:
%     signal = gen_signal(@(t) sin(t) + 2*sin(3*t), 2*pi)
%     sim_results = sim_operation(signal, 0.4)
%
%     opt = hybridset('plot_sim', 42, 'tanh_sim', 1e2)
%     sim_results = sim_operation(signal, 0.5, 'nointer', opt)
%
%   Both strategies generally need omniscient knowledge of the signal,
%   obtained through information from the dimensioning process. Therefore,
%   it cannot be applied to real problems without modification.
%
%   See also GEN_SIGNAL, HYBRIDSET, HYBRID.

% TODO integrate optional dims argument, which can handle simulations with
% dimensions that are not at a hybridisation line

[strategy, opt] = parse_hybrid_pair_input(varargin{:});

[base, peak, bw_int] = hybrid_pair(signal, cut, strategy, opt);

control = control_factory(cut, strategy, base, peak, opt);

ode = @(t, y) control(signal.fcn(t), bw_int.fcn(t), y);

odesol = opt.continuous_solver;

% TODO exclude to separate function which chooses depending on signal type
[t, y] = odesol(ode, [0 signal.period], [0 0], opt.odeset);

sim_results.base = base;
sim_results.peak = peak;
sim_results.type = signal.type;
sim_results.cut = cut;
sim_results.strategy = strategy;
sim_results.bw_int = bw_int;
sim_results.time = t;
sim_results.powers = y;

if opt.plot_sim
    plot_operation(sim_results, signal, opt)
end

end
