function result_matrix = analyze_study_results(study_results, showresults)
% ANALYZE_STUDY_RESULTS form, crest factor - leaf shape relations
%
% Conditions simulation data and tries to find functional relationsship
% between the shape of the leaf and the signal parameters form and crest
%
% Input:
%   study_results   result from study_batch_all and similar
%   showresults     bool, optional, default = 0
%                   print output and generates diagrams
%
% Output:
%   result_matrix   [[peak_x, peak_y, form, crest]; ...]

if nargin < 2
    showresults = 0;
end

study_results = add_peak_and_trans_to_study_results(study_results);

[peak_x, peak_y, form, crest] = cellfun(@extract_data_from_one_result, ...
                                        study_results);
result_matrix = [peak_x, peak_y, form, crest];

if showresults
    figure, semilogx(form, peak_x, 'x-'), grid on
    xlabel('form')
    ylabel('peak x')
    figure, semilogx(form, peak_y, 'x-'), grid on
    xlabel('form')
    ylabel('peak y')
    
    figure, semilogx(crest, peak_x, 'x-'), grid on
    xlabel('crest')
    ylabel('peak x')
    figure, semilogx(crest, peak_y, 'x-'), grid on
    xlabel('crest')
    ylabel('peak y')
end


end%mainfcn

% LOCAL FCNS

function [peakx, peaky, form, crest] = extract_data_from_one_result(result)
    % From one result element, which is by itself a 4x1 cell with
    % {signal parameters, simulation results, test case name, fcnformpara}
    % the parameters [peakx, peaky, form, crest] are returned
    form = result{2}.parameter(1);
    crest = result{2}.parameter(2);
    peakx = result{2}.peak(1);
    peaky = result{2}.peak(2);
end