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


