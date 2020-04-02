%Piece-wise linearization can be the solution when the objective functions or the constraints or both are non-linear
%A defined number of breakpoints will be denoted, and there corresponding linear function will be generated
function [joins] = piecewiseFunction( bandwidth)

Nsamp = bandwidth;     %number of data samples on x-axis
x = [0:Nsamp-1];    %this is your x-axis
Nlines =8;       %number of lines to fit

fx = 1./(Nsamp-x);  %generate something like your current data, f(x)
gx = NaN(size(fx));     %this will hold your fitted lines, g(x)

joins = round(linspace(1, Nsamp, Nlines+1));  %define equally spaced breaks along the x-axis

dx = diff(x(joins));   %x-change
df = diff(fx(joins));  %f(x)-change

m = df./dx;   %gradient for each section
%{
for i = 1:Nlines
   x1 = joins(i);   %start point
   x2 = joins(i+1); %end point
   gx(x1:x2) = fx(x1) + m(i)*(0:dx(i));   %compute line segment
end

subplot(2,1,1)
h(1,:) = plot(x, fx, 'b', x, gx, 'k', joins, gx(joins), 'ro');
title('Normal Plot')

subplot(2,1,2)
h(2,:) = loglog(x, fx, 'b', x, gx, 'k', joins, gx(joins), 'ro');
title('Log Log Plot')

for ip = 1:2
    subplot(2,1,ip)
    set(h(ip,:), 'LineWidth', 2)
    legend('Data', 'Piecewise Linear', 'Location', 'NorthEastOutside')
    legend boxoff
end
%}
end

