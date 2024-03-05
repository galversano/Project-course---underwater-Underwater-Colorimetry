# Project-course-Underwater-Colorimetry

Apply principles of underwater image formation
and colorimetry we learned in the course to a real-world dataset.

For this project i used this photos:

<img src="https://github.com/galversano/Project-course---underwater-Underwater-Colorimetry/assets/66177443/dd2421df-8a26-4b71-b1c6-350117b42683" width="700" height="300">


# Relevant parametres
%Number of charts in the pictures
```matlab
num_chart = 5;
 ```   
%Distance from the viewer
  ```matlab
index_depth=5;
 ```
%Number of patch you want to do the white balance 
```matlab
patch_number=4;
 ```

# Instructions

For each chart in the picture, identify and label the colors using the mask obtained in ex.1. 
Then, determine the depth of each chart using the method described in ex.2. 
Mark each chart accordingly and manually record the distance for each one. Save this information in the 'depth_array' parameters.

ex.3+ex.4 is for calculate and delete backscatter and calulate Dc:

<img src="https://github.com/galversano/Project-course---underwater-Underwater-Colorimetry/assets/66177443/e7c9a5e6-991e-47bd-b215-ffd509f4fc76" width="500" height="150">

ex.5+ex.6+ex.7 is to caululate the J_c and do white balance:

$$
J_c = D_c \cdot \exp(\beta^{D}_c z)
$$

ex.8+ex.9+ex.10+ex.11 is for do the transformation between RGB to XYZ and the to sRGB to get the right color like in the air.

$$
J_{c}(RGB) \rightarrow Jc_{wb}(RGB) \rightarrow XYZ_{wb} \rightarrow sRGB
$$

When index wb is white-balance

# Examples

The color in the water for the first chart:

<img src="https://github.com/galversano/Project-course---underwater-Underwater-Colorimetry/assets/66177443/24fdfd27-9e50-4eda-a453-6db12965cd24" width="500" height="300">


__After all the step we will get:__

<img src="https://github.com/galversano/Project-course---underwater-Underwater-Colorimetry/assets/66177443/91f505fd-7ffa-41d8-a196-c376f628ec25" width="500" height="300">


Reference for the picture:

<img src="https://github.com/galversano/Project-course---underwater-Underwater-Colorimetry/assets/66177443/982ecc8b-6f7b-4b4f-a956-25f082ed59cb" width="500" height="300">









