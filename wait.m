function wait(times)

% wait procedure for specified time.
%	
%	WAIT(TIMES)
%	  TIMES - number of seconds (can be fractional).
%	Stops procedure for N seconds.
%	
% By hadi veisi [veisi@ce.sharif.edu]

if nargin ~= 1
  error('Usage: WAIT(TIMES)');
end

drawnow
t1 = clock;
while etime(clock,t1) < times,end;
