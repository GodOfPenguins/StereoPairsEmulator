# StereoPairsEmulator

This is for a plugin that emulates a stereophonic microphone array. The emulated array can contain a main pair, a center microphone, and a flanking pair -- each pair and the center microphone are individually adjustable.

Currently in the middle of massive refactoring/rewriting, as the original write lacked certain key UI integrations and sprawled unnecessarily.

This audio plugin is being developed as a competition entry in the [2020 AES/MatLab plugin design competition](http://www.aes.org/students/awards/mpsc/). Some design/function allowances had to be made to accomodate the 2x2 I/O limitation dictated by the competition rules.

## Mic Options

This sections outlines the microphone control options.

### Mic Pairs

The main and flanking mic pairs are controlled as pairs with their functions operating to maintain each pair's reflected symmetry around the "center axis" of the mic array The following controls are available:

* Angular splay
* Distance
* Directivity
* Level
* Enable

#### Angular Splay

The angular splay of the microphone pair is the angle between the on-axis responses of the emulated microphones. As an example, the angular splay of the ORTF microphone technique is 110 degrees. While radians are used for internal calculations, the angular splay control is measured in degrees. The range of angular splay is between 

Combined with the directivity index (discussed below) this parameter helps define the interaural level (ILD) cues that are encoded into the stereophonic output based on how relatively "on-axis" the sound-source is to the left/right virtual microphones within each pair.

#### Distance

This is the lateral distance between the microphones (not the distance "from center"). For the main pair, this distance is measured in centimeters. For the flanking pair, the distance is in meters.

The maximum distance of the center array is 3 meters (300cm), and it has a minimum distance of 0cm. It should be noted here that using this plugin to emulate coincident microphone arrays is likely to be extremely CPU inefficient. 

The maximum distance of the flanks is 10 meteres. This was chosen based on an informal survey of classical location recordists, polling the widest array size that they had used.

The distance between the microphones in a stereo pair determines the weight of interaural time differences (ITD), with a greater distance correlating to a larger ITD value.

#### Directivity

The directivity factor of the microphone pair determines the polar pattern of each virtual microphone. The directivity factor is an abstract number ranging from 0 to 1; where the 0 and 1 integers corresponding to the two first-order microphone polar patterns (pressure, and pressure gradiant); and intermediate values indicating a blend between them. Thus, 0 indicates no directivity (omnidirecitonal), and 1 indicates maximum directivity (bidirectional/"figure-of-eight"). Key intermediate values are: 0.5 (ideal cardioid), 0.25 (ideal hypo-cardioid), and 0.75 (ideal hyper-cardioid).

* 0 -- Omnidirectional
* 0.25 -- Hypocardioid
* 0.5 -- Cardioid
* 0.75 -- Hypercardioid
* 1 -- Bidirectional

#### Gain trim

Each pair has an individual gain control so that the user can adjust the balance of sound between the mic pairs. The attenuation runs from 0 to -12dB. Please ensure proper gain-staging entering the plug-in as the internal trim is (necessarily) applied post-processing.

#### Enable

This toggle enables the correlated microphone pair. Switching off the toggle for a microphone pair will stop processing and emulation of those virtual microphones. This allows for the flanks to be disabled if only a center pair is used, or for other instances of this plugin to be run in parallel with the main pair disabled to allow for the emulation of more complex microphone arrays.

### Center Microphone

The center microphone is suitable in conjunction with the main pair for creating a "Decca-tree" configuration, or with the flanks to emulate the wide L-C-R microphone arrays sometimes seen with concern wind ensembles.

The center microphone has the following controls:

* Distance
* Directivity
* Level
* Enable

#### Controls

The above listed controls all, except the distance, work the same for the main and flanking microphone pairs, except that they only apply to the center microphone. There is no angular control over the center microphone -- it always points forward.

#### Distance

The distance control for the center microphone controls its distance forward, rather than its lateral displacement. The maximal distance is 1 meter (100cm), and the minimal distance allowed is 0cm. Like the main pair, the distance control is given in centimeters.

## Time Operations

There are two types of time-domain compensation used within the plugin: internal distance compensation to account for the physical spacing of the microphones, and the distance between the source and each microphone.

### Delay compensation

The delay compensation switch 