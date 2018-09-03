# README #

### What is this repository for? ###

* Matlab implementation of VideoDarwin.
* Version 1.0
* [CVPR paper](http://www.cv-foundation.org/openaccess/content_cvpr_2015/html/Fernando_Modeling_Video_Evolution_2015_CVPR_paper.html)

### Dependency ###

* vlfeat-0.9.18
* opencv-2.4.9
* liblinear-1.93
* libsvm-3.18
* improved trajectory implementation (binary)


### Contact ###

* Basura Fernando ( basura dot fernando at anu dot edu dot au)
* http://users.cecs.anu.edu.au/~basura/


### LICENSE & TERMS OF USE
----------------------
VideoDarwin code implements a sequence representation technique.
Copyright (C) 2015  Basura Fernando


### Terms of Use
--------------
This VideoDarwin software is strictly for non-commercial academic use only. 
This VideoDarwin code or any modified version of it may not be used for any commercial activity, such as:
1. Commercial production development, Commercial production design, design validation or design assessment work.
2. Commercial manufacturing engineering work
3. Commercial research.
4. Consulting work performed by academic students, faculty or academic account staff
5. Training of commercial company employees.

### License
-------
The analysis work performed with the program(s) must be non-proprietary work. 
Licensee and its contract users must be or be affiliated with an academic facility. 
Licensee may additionally permit individuals who are students at such academic facility 
to access and use the program(s). Such students will be considered contract users of licensee. 
The program(s) may not be used for commercial competitive analysis 
(such as benchmarking) or for any commercial activity, including consulting.

### FAQ ###
-----------

1. What type of non-linearity should I use for VideoDarwin?

It is important to use the correct non-linear function during the video sequence encoding. For Fisher vectors one may use sign square root.
ssr(x) = sing(x) .* sqrt(abs(x));

Alternatively one may exploit the imaginary kernels just simply using square-root non-linearity. In this case just using sqrt(x) one may obtain good results. Alternatively, one can use the following non-linear function which seems to work the best.

function o = rootExpandFmap(x)

    s =sign(x);

    y = sqrt(s.*x);

    o = [y.*(s==1) y.*(s==-1)]; 

end