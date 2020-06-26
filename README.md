# StereoPairsEmulator

This is for a plugin that emulates a stereophonic microphone array. The emulated array can contain a main pair, a center microphone, and a flanking pair -- each pair and the center microphone are individually adjustable.

Currently in the middle of massive refactoring/rewriting, as the original write lacked certain key UI integrations and sprawled unnecessarily.

## Mic Options

This sections outlines the microphone control options.

### Mic Pairs

The main and flanking mic pairs are controlled as pairs with their functions operating to maintain each pair's reflected symmetry around the "center axis" of the mic array The following controls are available:

* Angular splay
* Distance
* Directivity
* Level

#### Angular Splay

The angular splay of the microphone pair is the angle between the on-axis responses of the emulated microphones. As an example, the angular splay of the ORTF microphone technique is 110 degrees. While radians are used for internal calculations, the angular splay control is measured in degrees. The range of angular splay is between 

Combined with the directivity index (discussed below) this parameter helps define the interaural level (ILD) cues that are encoded into the stereophonic output based on how relatively "on-axis" the sound-source is to the left/right virtual microphones within each pair.

#### Distance

This is the lateral distance between the microphones (not the distance "from center"). For the main pair, this distance is measured in centimeters. For the flanking pair, the distance is in meters.

The distance between the microphones in a stereo pair determines the weight of interaural time differences (ITD), with a greater distance correlating to a larger ITD value.

#### Directivity

The directivity factor of the microphone pair determines the polar pattern of each virtual microphone. The directivity factor is an abstract number ranging from 0 to 1; where the 0 and 1 integers corresponding to the two first-order microphone polar patterns (pressure, and pressure gradiant); and intermediate values indicating a blend between them. Thus, 0 indicates no directivity (omnidirecitonal), and 1 indicates maximum directivity (bidirectional/"figure-of-eight"). Key intermediate values are: 0.5 (ideal cardioid), 0.25 (ideal hypo-cardioid), and 0.75 (ideal hyper-cardioid).

* 0 -- Omnidirectional
* 0.25 -- Hypocardioid
* 0.5 -- Cardioid
* 0.75 -- Hypercardioid
* 1 -- Bidirectional