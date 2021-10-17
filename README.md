# 3D-AUDIO--VBAP

An implementation of VBAP in Matlab.

VBAP implementation of:

* [Real-time Spatial Representation of Moving Sound Sources][research]

[research]: http://lib.tkk.fi/Diss/2001/isbn9512255324/article1.pdf

# Background

### VBAP (Vector Base Amplitude Panning)
Vector Base Amplitude Panning (VBAP) is a method for positioning virtual sources to multiple loudspeakers. The number of loudspeakers can be varying and they can be placed in an arbitrary 2-D or 3-D positioning. VBAP is a new formulation of the traditional panning method in which two or more loudspeakers emanate coherent signal with different amplitudes.

* Advantages of VBAP
  * VBAP is computationally efficient and accurate.
  * VBAP gives a maximum localization sharpness that can be achieve with amplitude panning since it uses at any one time the minimum number of loudspekers needed:one, two, or three.
  * The number of virtual sound sources or loudspeakers is not limited by the method.
  * Multiple virtual sources can be positioned in two – or three dimensional sound fields, even with very complex loudspeaker configurations.


### 2D VBAP
In 2-D VBAP the virtual source vector p is set to be a sum of weighted loudspeaker vectors l1 and l2.
After the weights g1 and g2 have been calculated and normalized, they can be used as gain factors of each channel.

![image](https://user-images.githubusercontent.com/86009768/137612970-bb925a34-1567-4b69-9a46-592ba8600b88.png)

* Vector Base Formulation
  * The two-channel stereophonic loudspeaker configuration is formulated as a two-dimensional vector base.
  * Two loudspeakers are positioned symmetrically with respect to the median plane.
  * The base is defined by unit-length vectors 𝑙_1=〖[𝑙_11,𝑙_12]〗^  𝑎𝑛𝑑〖 𝑙〗_2=〖[𝑙_21,𝑙_22]〗^ which are pointing toward loudspeaker 1 and 2.
  * The unit-length vector p= 〖"[" 𝑝_1,𝑝_2]〗^ , which points toward the virtual source can be treated as a linear combination of loudspeaker vectors.
  ![image](https://user-images.githubusercontent.com/86009768/137613277-687545f7-957d-4d64-8fc6-54ae46394fb6.png)

* 2D - VBAP for more than two loudspeakers
  ![image](https://user-images.githubusercontent.com/86009768/137613484-da645842-6a35-49fd-8ed6-f4f7f431739d.png)
  * The selected bases would be L_12 ,L_23, L_34, L_45, and L_51.
  * A system for virtual source positioning  is similary uses only two loudspeakers at an one time.
  * The virtual source can be produced by the loudspeaker base on the active arc of which the virtual source is located. 
  * When the sound moves from one pair to another, the gain factor of the loudspeaker, which is not used after the change becomes gradually zero before the change-over point.

* Implementation 2D VBAP for More than two loudspeakers
 
	 1. New direction vectors P(1.....n ) are defined. 
	 2. The right pairs are selected. 
	 3. The new gain factors are calculated. 
	 4. The old gain factors are cross faded to new ones and the loudspeaker bases are changed if necessary.

### 3D VBAP
3D VBAP is the method which can be applied to loudspeaker triangle of any shape. 
The gain factors are calculated similarly as in 2D case.
It needs to be a 'mesh' based on triangles, as any individual sound can only exist between the nearest three points. 
Third loudspeaker placed in an arbitrary position at the same distance from the listener as the other loudspeakers.
The virtual source can now within a triangle formed by the loudspeakers when viewed from the listener's position.
Sound sources are driven by coherent electrical signals with different amplitudes.

![image](https://user-images.githubusercontent.com/86009768/137615835-ba9c554b-95fd-46a8-86c8-efbd51e4ade0.png)

* Vector Base Formulation
  * The base is defined by unit−length vectors "  𝑙〗_1=[𝑙_(11 , ) 𝑙_12, 𝑙_13  ], 𝑙_2=[ 𝑙_21  , 𝑙_22  , 𝑙_23  ], 𝑙_3=[𝑙_31, 𝑙_32,𝑙_33]  which are pointing toward loudspeaker 1 ,2 and 3.
  * The unit-length vector p=[𝑝_1,𝑝_2,𝑝_3 ],  which points toward the virtual source can be treated as a linear combination of loudspeaker vectors.
    ![image](https://user-images.githubusercontent.com/86009768/137616615-7649c953-b2a9-4e6e-bf1d-e3e454b02f0a.png)	
 
  * *Spherical coordinate system
    ![image](https://user-images.githubusercontent.com/86009768/137617364-c8d18dd8-2944-445d-bff4-f946060bc0d6.png)

* 3D - VBAP for more than three loudspeakers
  * The active triangle of base should not be intersecting.
  * The active triangle should be selected so that maximum localization accuracy in each direction is provided. 
  * Three loudspeakers are selected according to the active triangle where the virtual source is located.



# Experimental results

### 2D VBAP

* Function
1. Localization
   - 0 ~ 360 dgree
2. Moving source
   - clockwise
   - counterclockwise 

  * Localization 
    * Simulation process
    1. Calculation gain1, gain2

    2. Use HRTF database (Convolution input & HRIR)
       Loudspeaker_90 = [Left_90 , Right_90] (matrix) 
       Loudspeaker_120 = [Left_120,Right_120] (matrix) 
    
    3. Amplitude panning
      Loudspeaker_90 * gain1,
      Loudspeaker_120 * gain2

    4. Loudspeaker_90 * gain1 +  Loudspeaker_120 * gain2 = [Left_Virtual Source, Right_Virtual Source] (matrix) 

     ![image](https://user-images.githubusercontent.com/86009768/137618065-481b163f-7ec1-467e-819c-9d6841be4573.png)
    
  * Moving source 
    * Simulation process
      ![image](https://user-images.githubusercontent.com/86009768/137618776-b6813ce3-5f44-452f-83e0-5a9c5a9aca57.png)
      1. After dividing the sound source into 360 frames (1~360 degrees), select the two loudspeakers for each frame angle.
      2. After finding g1 and g2 with VBAP method, do Amplitude panning.
      3. Apply the same method from the first frame (1 degree) to the last frame (360 degree).
      (* Implementation is possible by calculating only the gains at the desired position without using a filter.)
    
