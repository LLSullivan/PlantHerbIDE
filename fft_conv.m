function c = fft_conv(a, b)
%FFT_CONV  Convolution and polynomial multiplication.
%	C = FFT_CONV(A, B) convolves vectors A and B.  The resulting
%	vector is length LENGTH(A)+LENGTH(B)-1.
%	If A and B are vectors of polynomial coefficients, convolving
%	them is equivalent to multiplying the two polynomials.
%
%	Compare with the
%
%	See also XCORR, DECONV, CONV2.
%
%	Based on CONV by:
%	  J.N. Little 4-21-85
%	  Revised 9-3-87 JNL	
%	  Copyright (c) 1984-94 by The MathWorks, Inc.
%	Ammended by:
%	  Mike Neubert 6-14-95

na = max(size(a));
nb = max(size(b));

% Convolution, polynomial multiplication, and FIR digital
% filtering are all the same operations.  This routine uses
% the fftfilter to do the operation. 

% CONV(A,B) is the same as CONV(B,A), but we can make it go
% substantially faster if we swap arguments to make the first
% argument to filter the shorter of the two.
if na > nb
    if nb > 1
        a(na+nb-1) = 0;
    end
    c = fftfilt(b, a);
else
    if na > 1
        b(na+nb-1) = 0;
    end
    c = fftfilt(a, b);
end
