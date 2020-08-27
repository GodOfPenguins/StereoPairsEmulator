# StereoPairsEmulator

This is for a plugin that emulates a stereophonic microphone array. The emulated array can contain a main pair, a center microphone, and a flanking pair -- each pair and the center microphone are individually adjustable.

This audio plugin was developed as a competition entry in the [2020 AES/MatLab plugin design competition](http://www.aes.org/students/awards/mpsc/). Some design/function allowances had to be made to accomodate the 2x2 I/O limitation dictated by the competition rules.

For a more detailed explaination of how this processor works, see the technical documentation (still WiP).

## Sound Source Options

The sound source is placed on the virtual sound stage using a familiar, angular panning control along with a distance control. If time delay compensation and flanking/center microphones are not being used, then it is unlikely that the source distance control will be necesary and and value greater than the width of the main pair should be sufficient -- noting that a greater width between the main stereo pair correlates to a more narrow stereo recording angle.

The two control options for the sound source are:

* Angle
* Distance

### Angle

The angle of the sound source is its deviation from the center line, rotated in a half-circle to the right or left. It is important to note that the angle is rotational, and the distance from the center-point of the microphone array is kept constant.

The angle of rotation is ±90 degrees, with negative numbers representing rotation to the left, and positive numbers representing rotation to the right. This yields a potential soundstage width of 180 degrees, which should accomodate most recording needs for stereo recording.

### Distance

The distance of the sound source represents its distance from the center of the array. The distance is measured in meters, and ranges from 0 to 15 meters.

## Mic Options

The microphones are divided into the two pairs (main and flanking pairs) and a center microphone, for a total of five usable virtual microphones. The control options of the microphones are outlined below.

### Mic Pairs

The main and flanking mic pairs are controlled as pairs with their functions operating to maintain each pair's reflected symmetry around the "center axis" of the mic array The following controls are available:

* Angular splay
* Distance
* Directivity
* Level
* Width
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

#### Width

The width control controls the amount of outward panning for the microphones. This is not equivalent to stereo widening, rather this is just an abstraction of a standard panning knob pair. Turning the width to its maximum value is the equivalent of "hard panning" the two virtual microphones left and right, while turning the value to its minimum value is the equivalent of center panning both microphones.

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

The delay compensation switch enables time of arrival compensation between the microphones in the array and the sound source. This can be used to aid in time-delay compensation when blending a spot microphone into a recording done with a real main-array. This should be disabled unless explicity needed.

### Speed of sound adjustment

This allows for the user to adjust the speed of sound to account for local variations -- again, most useful for blending spot microphones into recordings using real main arrays. 

This adjustment will apply to both the delay compensation and the inter-microphone time-difference calculations. The default calculations in the plugin use 343m/s as the usual speed of sound, and the adjustment parameter allows for ±10m/s of compensation. This range of adjustment should account for realistic concert hall temperture/humidity variation.

### Inter-microphone time differences

Internally, the plugin calcultes the time of arrival for the microphone array, and delays each microphone based on the relative distances. When the delay compensation is enabled, then the distance between each microphone and the sound source is calculated, and a per-microphone delay is used based on the distance and speed of sound.

However, when the delay compensation is disabled, the inter-microphone distances area calculated and delays are based on how much further any microphone is from the closest microphone, with the closest virtual microphone not recieving any delay.

The internal time adjustment for the array cannot be disabled, to maintain the presence of ITD cues.

## Level Adjustment

Traditionally, the spacing of microphones is considered to only have an effect on the time-of-arrival for the sound; however, for widely-spaced microphones (such as flanking mics) and/or sound source placements that considerably closer to one microphone than the others, there can be perceptable level difference based on the distance and propogation of sound pressure in the space.

A notable example of this would be use the use of flanking microphones in an orchestral recording. A cello near the edge of the stage would be considerable closer to the right flank microphone than the left. This level difference resulting from the propogation of sound could be quite significant -- even to the point of becoming more prominant in localisation than the precedence effect.

Actually modeling the appropriate propogation of sound to account for this is not practical for the purposes of a VST plugin, as much of the manner in which sound actually propogates depends on the sound source's facing an statistical directivity data, as well as the physical construction and dimensions of the sound stage. To account for all of these factors would be a venture into physical modelling at a level that would be unusable in most production environments, and likely far surpass the needed realism at the extreme expense of computational efficiency.

Therefore, the plugin includes several different compensation options which can be used as abstractions for this effect, which can be selected based on personal preference and situational needs:

* No compensation
* Flanks only
* Pairwise
* Full Array

There is also an option to select the amount of level adjustment.

* -1.5dB
* -3dB
* -6dB

### Flanks only

In most situations where the distance-based level differences will be significant, it will be between the flanking microphones. To accomodate this difference, since the flank levels can be set independently of the mains, the option to have distance-level compensation apply only to the flanks is included, and is expected to be suitable for a majority of user needs.

### Pairwise

Since the inidividual parts of the array can have their levels adjusted, the second option applies level adjustment to the main and flank pairs individually. This may be helpful in some circumstances for widely spaced arrays.

The level adjustment with this setting considers each pair separately. If the center microphone is used, then it will be considered part of the main array.

### Full Array

This setting applies the level adjustment to every microphone in the array, lowering the level based on the sound source's distance from each microphone realtive to the closest microphone from the source.

### Adjustment Strength

There are three options for the strength of the level adjustment, to act as abstractions for the propogation of sound under different conditions and for instruments with different directivity factors. The value listed indicates the amount of damping per doubling of distance from the sound source in decibels.
