# Code overview
## functions:
	- convertAllImages.m: convert all images from JPG format to PNG format.
	- extractAllImages.m: extract features from all images, using 'compute_descriptors' library in lib/feature_detector.
	- quantizeAllImages.m: apply flann kd-tree to get the nearest bins
	- makeAllBow.m: make BoW vector by assigning features to the the nearest bins and computing their weights
## groundtruth:
	- compute_ap.cpp: compute average precision for each query
## lib:
	### feature_detector:
		- compute_descriptors.mac, compute_descriptors_32bit.ln, compute_descriptors_64bit.ln: extract features and compute descriptors for MAC/Linux32/Linux64, respectively
	### flann-1.8.4: library for ...
	### vlfeat-0.9.19: library for ....
## createParams.m: 
## step1_extract.m: extract features of all query and data images
## step2_quantize.m: perform quantization
## step3_query.m: process all queries and retrieve ranked lists
## step4_evaluate.m: compute mean average precision of all ranked lists

# How to run
- copy the data to directory: ....
- run step1, step2, step3, step4 sequentially.
- the result is outputted(?) to directory: ....