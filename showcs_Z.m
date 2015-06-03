function [varargout] = showcs_Z(T,l)
% same as showcs but for Zatsiorsky's 4x4 matrix 
% [ I 0]
% [ t R]
%
% [varargout] = showcs(T,l)
%
% Usage:
%
% [h] = showcs(T,l)
%
% Displays the three coordinate axes defined by T
% as lines with length 'l' and returns a handle to it
%
% [X,Y,Z] = showcs(T,l)
%
% Returns the X, Y and Z-values for the three line objects
% representing the coordinate frame corresponding to T
%
%	h	handles (3x1 vector)
%	X,Y,Z	x-,y-,z-values for the line objects (3x2 matrices)
%
%	l	lenght of axes. If omitted, l is set to 1
%


if nargin==1
  l = 1;
end


start = [T(2:4,1)'; T(2:4,1)'; T(2:4,1)']';
stop = start + l*[T(2:4,2)'; T(2:4,3)'; T(2:4,4)']';

X = [start(1,:);stop(1,:)];
Y = [start(2,:);stop(2,:)];
Z = [start(3,:);stop(3,:)];

if nargout <= 1
  h = line(X,Y,Z);
  varargout{1} = h;
else
  varargout{1} = X';
  varargout{2} = Y';
  varargout{3} = Z';
end


% h = arrow('start',start,'stop',stop,'LineStyle','-','color','b');
% h = sline(start,stop);
% h = h(1,1);