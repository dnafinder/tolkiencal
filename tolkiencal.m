function out = tolkiencal(dateIn, format)
% TOLKIENCAL converts a Gregorian date into the Shire calendar (Shire Reckoning).
%
% TOLKIENCAL is my personal tribute to my favourite writer: J.R.R. Tolkien.
% The calendar used by the Hobbits of the Shire divided the year into twelve
% months which, unlike the irregular months of Roman and modern Europe, were
% of equal length: every month in the Hobbit year had exactly thirty days.
% This totals only 360 days, so the left-over five or six additional days in
% each year were invested in a pair of festivals, one at each solstice.
%
% This function maps a Gregorian date to the corresponding date in the
% Shire calendar, assuming that Midyear's Day coincides with the summer
% solstice on 21 June of that year (valid approx. 1600–2399 A.D.).
%
% SYNTAX:
%   tolkiencal()
%   tolkiencal(dateIn)
%   tolkiencal(dateIn, format)
%   shireStr = tolkiencal(...)
%
% INPUT:
%   dateIn — Optional, one of:
%            • datetime
%            • datenum (numeric)
%            • char/string date ('dd/mm/yyyy', etc.)
%            Default = today
%
%   format — Optional. Used only when dateIn is char/string.
%            Allowed formats:
%            'dd-MMM-yyyy', 'MM/dd/yy', 'MMM.dd,yyyy',
%            'MM/dd/yyyy', 'dd/MM/yyyy', 'yy/MM/dd', 'yyyy/MM/dd'
%
% OUTPUT:
%   If no output argument → displays the date.
%   If output argument is requested → returns the Shire date string.
%
% EXAMPLE:
%   tolkiencal('04/06/2007')
%   % → Hevensday 15 Forelithe 2007
%
% AUTHOR:
%   Created by Giuseppe Cardillo
%   giuseppe.cardillo.75@gmail.com
%
% CITATION:
%   Cardillo G. (2007–2025).
%   Tolkiencal: convert a date into the Shire calendar.
%   https://github.com/dnafinder/tolkiencal


%% Setup: defaults and allowed formats
validFormat = {'dd-MMM-yyyy','MM/dd/yy','MMM.dd,yyyy','MM/dd/yyyy', ...
               'dd/MM/yyyy','yy/MM/dd','yyyy/MM/dd'};
defaultFormat = validFormat{5}; % 'dd/MM/yyyy'

if nargin < 1
    dateIn = datetime('today');
end
if nargin < 2
    format = defaultFormat;
end

if isstring(format), format = char(format); end


%% Convert to datetime
if isa(dateIn,'datetime')
    dt = dateshift(dateIn,'start','day');

elseif isnumeric(dateIn)
    dt = datetime(dateIn,'ConvertFrom','datenum');
    dt = dateshift(dt,'start','day');

elseif ischar(dateIn) || isstring(dateIn)
    if isempty(find(strcmp(validFormat,format),1))
        error('Invalid format. Allowed formats are: %s', strjoin(validFormat,', '));
    end
    try
        dt = datetime(dateIn,'InputFormat',format);
    catch
        error('This is not a valid date for the specified format.');
    end
    dt = dateshift(dt,'start','day');

else
    error('Invalid date input type.');
end

if ~isscalar(dt)
    error('Input date must be a scalar.');
end


%% Shire calendar metadata
SpecialDays = {'Second Yule','First Lithe','Midyear''s Day', ...
               'OverLithe','Second Lithe','First Yule'};

Months = {'Afteryule','Solmath','Rethe','Astron','Thrimidge',...
          'Forelithe','Afterlithe','Wedmath','Halimath',...
          'Winterfilth','Blotmath','Foreyule'};

Weekdays = {'Sterday','Sunday','Monday','Trewsday',...
            'Hevensday','Mersday','Highday'};


%% Build virtual Shire year (366 days for leap year)
val = [-1 1 2 3 4 5 6 -2 -3 -4 -5 7 8 9 10 11 12 -6];
len = [1 30 30 30 30 30 30 1 1 1 1 30 30 30 30 30 30 1];

monthCode = repelem(val, len);          % month or special-day code
dayOfMonth = [0, repmat(1:30,1,6), zeros(1,4), repmat(1:30,1,6), 0];

weekdayIndex = [repmat(1:7,1,26), 0,0, repmat(1:7,1,26)];


%% Adjust for Gregorian leap year (remove OverLithe)
Y = year(dt);
isLeap = (mod(Y,400)==0) || (mod(Y,4)==0 && mod(Y,100)~=0);

if ~isLeap
    monthCode(184)  = [];
    dayOfMonth(184) = [];
    weekdayIndex(184) = [];
end


%% Map Gregorian date → Shire date
MidyearDate = datetime(Y,6,21);

if dt <= MidyearDate
    idx = 183 + isLeap - days(MidyearDate - dt);
else
    idx = 183 + isLeap + days(dt - MidyearDate);
    if idx > 365 + isLeap
        idx = idx - (365 + isLeap);
        Y = Y + 1;
    end
end

code = monthCode(idx);

if code < 0
    % Special day
    if code == -3 || code == -4
        shireStr = sprintf('%s %d', SpecialDays{abs(code)}, Y);
    else
        shireStr = sprintf('%s %s %d', ...
            Weekdays{weekdayIndex(idx)}, SpecialDays{abs(code)}, Y);
    end
else
    % Normal date
    shireStr = sprintf('%s %d %s %d', ...
        Weekdays{weekdayIndex(idx)}, dayOfMonth(idx), Months{code}, Y);
end


%% Output
if nargout > 0
    out = shireStr;
else
    disp(shireStr);
end

end
