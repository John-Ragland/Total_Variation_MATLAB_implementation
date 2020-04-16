function [un, kn] = TVdeblur(image, alpha1, alpha2, gamma, beta, iterations)
%TVDEBLUR Blind Deconvolution Using Total Variation
%   [est_image, est_psf] = TVdeblur(image, alpha1, alpha2, gamma, beta, iterations)
%   reterns the estimated point spread function and reconstructed image
%   calculated from the Total Variation Blind Deconvolution Algorith [1]
%
%   INPUT ARGUMENTS:
%   image - image of shape [H, W]
%   alpha1 - TV parameter from equation (3) in [1]
%   alpha2 - TV parameter from equation (3) in [1]
%   gamma - learning rate for estimated kernel
%   beta - learning rate for reconstructed image
%   iterations - number of iterations
%
%   OUTPUT ARGUMENTS:
%   est_image - reconstructed image of shape [H, W]
%   est_ker - estimated point spread function (maximum size of kernel is
%       assumend to be [15 15]
%
%   SOURCES:
%   [1] Chan, Tony F., and Chiu-Kwong Wong. “Total Variation Blind Deconvolution.”
%       IEEE Transactions on Image Processing 7, no. 3 (March 1998): 370–75.

    un = image;
    kn = zeros(7,7);

    kn_size = size(kn);
    z = image((kn_size(1)-1)/2+1:end-((kn_size(1)-1)/2),(kn_size(2)-1)/2+1:end-((kn_size(2)-1)/2));

    time_sum = 0;
    
    for n = 1:iterations
        tic;
        %Calculate dF/dKn where F is (3) in [1]
        dkn = conv2(rot90(rot90(un)),conv2(un,kn,'valid')-z,'valid') - alpha2*dTV(kn);

        %Update Kn using Gradient Descent
        kn = kn - beta*dkn;
        
        %Impose Constraints on Kn
        kn = (kn>0).*kn;
        kn = (kn + rot90(rot90(kn)))/2;
        kn = kn./(sum(kn,'all'));

        %Calculate dF/dUn where F is (3) in [1]
        dun = conv2(conv2(un,kn,'valid')-z,rot90(rot90(kn))) - alpha1*(dTV(un));

        %Update Un using Gradient Descent
        un = un - gamma*dun;
        un = (un>0).*un;

        %Display Percent Complete
        clc
        fprintf('Percent Complete: %f%%\n',n/iterations*100); 
        time_taken = toc;
        time_sum = time_taken + time_sum;
        time_avg = time_sum/n;
        fprintf('Estimated Time Remaining: %f minutes',(iterations-n)*time_avg/60);
    end

end

