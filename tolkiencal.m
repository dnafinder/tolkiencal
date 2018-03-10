function tolkiencal(date,format)
%TOLKIENCAL is my personal tribute to my favourite writer: J.R.R. Tolkien.
%The calendar used by the Hobbits of the Shire divided the year into twelve
%months which, unlike the irregular months of Roman and modern Europe, were
%of equal length: every month in the Hobbit year had exactly thirty days.
%This totals only 360 days, so the left-over five or six additional days in
%each year were invested in a pair of festivals, one at each solstice. The
%two days of Yule fell around the Winter solstice, between December and
%January; the first day of Yule was the last day of one year, and the
%second day of Yule was the new-year's day of the next. Six months later
%the festival of Lithe ornamented the Summer solstice, and lasted either
%three or four days: the first day of Lithe began the festival, followed by
%Midyear's Day itself, followed in leap years by an "Overlithe", and then
%the festival ended on the second day of Lithe. 
%In European calendars a given date, like January the first, falls on a
%different day of the week every year: sometimes it is a Monday, sometimes
%a Tuesday, sometimes another day. The Hobbits prevented this disorder by
%considering neither Midyear's Day nor, in leap years, the Overlithe, to be
%a day of the week. The first twenty-six weeks of the year ran
%continuously, starting on the second day of Yule and ending with the first
%day of Lithe. Then came Midyear's Day, and the Overlithe in leap-years,
%making a sort of long weekend; we would think of them as one or two extra
%days falling between a Saturday of one week and the Sunday of the next.
%Then the next Shire week began with the second of Lithe, beginning the
%twenty-six final weeks of the year which ended on the second day of Yule.
%Because of this Hobbit innovation that kept the weeks in the same place
%every year, which they called the Shire-reform, the calendar is always
%correct, unlike European calendars which have to be printed differently
%every year.
%
% Syntax: 	TOLKIENCAL(date,format)
%      
%     Input:
%           DATE (default=Today). 
%           FORMAT (default='dd/mm/yyyy')
%     Outputs:
%           The corresponding date in the Shire Calendar.
%
%      Example: 
%      Calling on Matlab the function: tolkiencal('04/06/2007')
%
%      the answer is:
%      Hevensday 15 Forelithe 2007
%
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) Tolkiencal: convert a date into the Shire calendar.
% http://www.mathworks.com/matlabcentral/fileexchange/18044

%input parser
validFormat={'dd-mmm-yyyy','mm/dd/yy','mmm.dd,yyyy','mm/dd/yyyy','dd/mm/yyyy','yy/mm/dd','yyyy/mm/dd'};
defaultFormat = validFormat{5};
defaultDate = datestr(now,defaultFormat);
validationFormat=@(x) ischar(x) && ~isempty(find(contains(validFormat,x),1));
validationDate=@(x,y) ischar(x) && isequal(datestr(datenum(x,y),y),x);

if nargin==0
     format=defaultFormat;
     date=defaultDate;
elseif nargin==1
     format=defaultFormat;
end

if ~validationFormat(format)
    txt=sprintf('Warning: This is not a valid format\nValid formats are:\ndd-mmm-yyyy\nmm/dd/yy\nmmm.dd,yyyy\nmm/dd/yyyy\ndd/mm/yyyy\nyy/mm/dd\nyyyy/mm/dd\n');
    error(txt); %#ok<SPERR>
end
   
if ~validationDate(date,format)
    error('This is not a valid Date for the specified format')
end

%Special Days
SD={'Second Yule' 'First Lithe' 'Midyear''s Day' 'OverLithe' 'Second Lithe' 'First Yule'};
%Name of Months
MONTHS={'Afteryule' 'Solmath' 'Rethe' 'Astron' 'Thrimidge' 'Forelithe' 'Afterlithe' 'Wedmath' 'Halimath' 'Winterfilth' 'Blotmath' 'Foreyule'};
%Name of days
DAYS={'Sterday' 'Sunday' 'Monday' 'Trewsday' 'Hevensday' 'Mersday' 'Highday'};

%Construct a virtual calendar based on leap year
val=[-1 1 2 3 4 5 6 -2 -3 -4 -5 7 8 9 10 11 12 -6];
len=[1 30 30 30 30 30 30 1 1 1 1 30 30 30 30 30 30 1];
m=rldecode(val,len); %twelve months...
clear val len
d=[0 ...
    repmat((1:1:30),1,6)...
    zeros(1,4)...
    repmat((1:1:30),1,6)...
    0]; %days of months....
wd=[repmat((1:1:7),1,26) ...
    0 0 ...
    repmat((1:1:7),1,26)]; %weekdays...

Y=year(date,format); %Retrieve the year
leap=(~(mod(Y,400)) | (~(mod(Y,4)) & (mod(Y,100)))); %check if it is a leap year

%if year is not a leap year then delete the 'OverLithe' day 
if ~leap 
    m(184)=[];
    d(184)=[];
    wd(184)=[];
end

%The Midyear's day is the day of the Summer solstice, in practice
%21-Jun from 1600 to 2399 A.D. (see my file Eqnsol). In non leap years
%21-Jun is the Midyear's Day; in the leap year it is OverLithe day.
mdy=datenum([Y 6 21 0 0 0]); 
td=datenum(date,format);
if td<=mdy %if the input date is before 21-June
    c=183+leap-(mdy-td); %day of the year
    if m(c)<0 %if it is a Special day...
        if m(c)==-3 || m(c)==-4 %if it is Midyear's day or OverLithe day there is not weekday
            disp([SD{abs(m(c))} ' ' num2str(Y)])
        else 
            disp([DAYS{wd(c)} ' ' SD{abs(m(c))} ' ' num2str(Y)])
        end
    else %else display day in the format dddd dd/mmmm/yyyy
        disp([DAYS{wd(c)} ' ' num2str(d(c)) ' ' MONTHS{m(c)} ' ' num2str(Y)])
    end
else %else if the input date is after 21-June
    c=183+leap+(td-mdy); %day of the year
    if c>365+leap %The first day of the year is not 01-January....
        c=c-(365+leap);
        Y=Y+1;
    end
    if m(c)<0 %if it is a Special day...
        disp([DAYS{wd(c)} ' ' SD{abs(m(c))} ' ' num2str(Y)])
    else
        disp([DAYS{wd(c)} ' ' num2str(d(c)) ' ' MONTHS{m(c)} ' ' num2str(Y)])
    end       
end

function x=rldecode(val,len)
I = cumsum(len);
J = zeros(1, I(end));
J(I(1:end-1)+1) = 1;
J(1) = 1;
x = val(cumsum(J));
