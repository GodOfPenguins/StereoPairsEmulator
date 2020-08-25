classdef StereoPairsEmulator < audioPlugin
    %STEREOPAIRSEMULATOR Emulates the level and time differences of a
    %microphone array
    %   This plugin emulates the level and time cues of a microphone array.
    %   It takes in a mono input and outputs a stereo signal based on the
    %   virtual microphone set-up and the mixdown settings.
    
    properties
        % ------UI PROPERTIES-----
        % Angular splay values for the mic pairs
        mainsSplay = 90; 
        flanksSplay = 0;
        % Distances for each pair of microphones
        % Note that the pairs distances are lateral, while the center
        % distance will be vertical,
        mainsDistance = 200;
        flanksDistance = 5; 
        centerDistance = 150; % Distance forward, not lateral
        % Polar pattern values for the microphones
        % These will be a number from 0 to 1 where omni is 0 and
        % bidirectional is 1
        pMains = 0.5;
        pFlanks = 0;
        pCenter = 0.5; % This could probably be the same as the main pair...
        % Gain adjustments
        gainMains = 0;
        gainFlanks = -6;
        gainCenter = -3;
        % Stereo width adjustments
        mainsWidth = 1;
        flanksWidth = 1;
        % Toggles for pair use
        useMains = true;
        useFlanks = true;
        useCenter = true;
        % Distance compensation
        useDistCompensation = false;
        speedOfSoundTrim = 0;
        % Level adjustment for the array
        levelAdjustmentEnum = 'None';
        levelAdjStrengthEnum = '-6';
        % Sound source properties
        sourceAngle = 0;
        sourceDistance = 5;   
    end
    properties
        sampleRate = 48000; % default sample rate
        delayLine;
        micScalarArray = [0 0 0 0 0];
        micTimeArray = [0 0 0 0 0];
        micMixArray = [0 0 0];
        micPanArray = [0 0 0 0];
        micOutputScalars = [0 0 0 0 0; 0 0 0 0 0];
        dampingScalars = [0 0 0 0 0];
        recalcFlag = 1;
        lpCalcFlag = 1;
        mixCalcFlag = 1;
    end
    properties(Dependent)
        sourcePos;
        speedOfSound;
        mDistArray;
        mPArray;
        mSplayArray;
        mEnabledArray;
        mainLevel;
        flankLevel;
        centerLevel;
        mainPan;
        flankPan;
        centerPan;        
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
            'PluginName','Stereo Pairs Emulator',...
            'VendorName','Fat Penguin Sound',...
            'VendorVersion', '0.0.4',...
            'InputChannels',1,...
            'OutputChannels',2,...
            audioPluginParameter('sourceAngle',...
                'DisplayName','Source Angle',...
                'Mapping',{'lin',-90,90},... % This will need to be flipped in calculations... also converted to radians.
                'Style','rotaryknob',...
                'Layout',[4,12;5,13],...
                'DisplayNameLocation','Above',...
                'Label','�'),...
            audioPluginParameter('sourceDistance',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,15},... % This is in meters -- controls the maximum distance the source can be away from the center of the main array
                'Style','rotaryknob',...
                'Layout',[4,10;5,11],...
                'DisplayNameLocation','Above',...
                'Label','m'...
            ),...
            audioPluginParameter('mainsDistance',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,300},... % Distance between the main stereo pair. Needs to be converted to m for calculations.
                'Style','Rotaryknob',...
                'Layout',[4,1;5,2],...
                'DisplayNameLocation','Above',...
                'Label','cm'...
            ),...
            audioPluginParameter('flanksDistance',...
            'DisplayName','Distance',...
                'Mapping',{'lin',0,10},... % Distance between the flanking stereo pair. This distance is in meters.
                'Style','Rotaryknob',...
                'Layout',[4,4;5,5],...
                'DisplayNameLocation','Above',...
                'Label','m'...
            ),...
            audioPluginParameter('centerDistance',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,200},... % Distance of the centre mic (forward). In cm and needs to be converted.
                'Style','Rotaryknob',...
                'Layout',[4,7;5,8],...
                'DisplayNameLocation','Above',...
                'Label','cm'...
            ),...
            audioPluginParameter('mainsSplay',...
                'DisplayName','Angle',...
                'Mapping',{'lin',0,180},... % Angle between the microphones in degrees
                'Style','Rotaryknob',...
                'Layout',[7,1;8,2],...
                'DisplayNameLocation','Above',...
                'Label','�'...
            ),...
            audioPluginParameter('flanksSplay',...
                'DisplayName','Angle',...
                'Mapping',{'lin',0,180},... % Angle between the microphones in degrees
                'Style','Rotaryknob',...
                'Layout',[7,4;8,5],...
                'DisplayNameLocation','Above',...
                'Label','�'...
            ),...
            audioPluginParameter('pMains',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... % We'll make this so that it increases directivity as it moves towards 1, that'll make more sense for the user
                'Style','Rotaryknob',...
                'Layout',[10,1;11,2],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('pFlanks',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... 
                'Style','Rotaryknob',...
                'Layout',[10,4;11,5],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('pCenter',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... 
                'Style','Rotaryknob',...
                'Layout',[10,7;11,8],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('gainMains',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},... % This range could be wider, but for mixing, this is probably the most realistically useful range. Any lower than -20 and the mics should just be turned off.
                'Style','vslider',...
                'Layout',[16,1;19,2],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('gainFlanks',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},...
                'Style','vslider',...
                'Layout',[16,4;19,5],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('gainCenter',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},...
                'Style','vslider',...
                'Layout',[16,7;19,8],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('useMains',...
                'DisplayName','Mains',...
                'Style','vrocker',...
                'Layout',[10,10;11,11],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('useFlanks',...
                'DisplayName','Flanks',...
                'Style','vrocker',...
                'Layout',[10,12;11,13],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('useCenter',...
                'DisplayName','Centre',...
                'Style','vrocker',...
                'Layout',[13,10;14,11],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('speedOfSoundTrim',...
                'DisplayName','SoS Trim',...
                'Mapping',{'lin',-10,10},... % Based on an estimate of temperture values on a concert hall, giving a range of speed of sound values for potential tempertures.
                'Style','Rotaryknob',...
                'Layout',[7,10;8,11],...
                'DisplayNameLocation','Above',...
                'Label','m/s'...                
            ),...
            audioPluginParameter('useDistCompensation',...
                'DisplayName','Dist, Compensation',...
                'Style','vrocker',...
                'Layout',[7,12;8,13],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('levelAdjustmentEnum',...
                'DisplayName','Level-Distance Compensation',...
                'Style','dropdown',...
                'Mapping',{'enum','None','Flanks Only','Pairwise','Full Array'},...
                'Layout',[16,10;16,13],...
                'DisplayNameLocation', 'Above'...
            ),...
            audioPluginParameter('levelAdjStrengthEnum',...
                'DisplayName','Level Adjustment Strength',...
                'Style','dropdown',...
                'Mapping',{'enum','-6','-3','-1.5'},...
                'Layout',[18,10;18,13],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('mainsWidth',...
                'DisplayName','Width',...
                'Style','Rotaryknob',...
                'Mapping',{'lin',0,1},...
                'Layout',[13,1;14,2],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('flanksWidth',...
                'DisplayName','Width',...
                'Style','Rotaryknob',...
                'Mapping',{'lin',0,1},...
                'Layout',[13,4;14,5],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginGridLayout( ...
                'RowHeight',[10, 10, 20, 50, 50, 20, 50, 50, 20, 50, 50, 20, 50, 50, 20, 50, 50, 50, 50, 20],...
                'ColumnWidth',50 * ones(1,13),...
                'RowSpacing',10,...
                'ColumnSpacing',10,...
                'Padding',[20 20 20 20]...
                )...
        );
    end
    properties(Constant)%Some convenience numbers
        hpi = pi/2;
        c = 343;
    end
    
    methods
        function plugin = StereoPairsEmulator %This is the constructor for the plugin            
            plugin.delayLine = dsp.VariableIntegerDelay(... % The VID needs to be initialised here in the constructor
            'MaximumDelay', 11520,... % 60ms @ 192kHz
            'InitialConditions',0 ...
        ); 
        end
        function out = process(plugin, in) %Actual processing here
            % Calculate values
            if plugin.recalcFlag == 1
                plugin.lpCalcFlag = 1;
                plugin.mixCalcFlag = 1;
                [plugin.micScalarArray, plugin.micTimeArray] = ... % Update the mic array properties
                    updateMicArray(...
                    plugin.mDistArray,...
                    plugin.mSplayArray,...
                    plugin.mPArray,...
                    plugin.sourcePos,...
                    plugin.speedOfSound,...
                    plugin.mEnabledArray,...
                    plugin.sampleRate);
                % Adjust for time of arrival correction if not in use
                if plugin.useDistCompensation == false
                    plugin.micTimeArray = timeOfArrivalAdjustment(plugin.micTimeArray);
                end          
                plugin.recalcFlag = 0; % Turn off the recalculation flag once it's done.
            end
            % Calculate mixbus processing
            if plugin.lpCalcFlag == 1
                plugin.mixCalcFlag = 1;
                plugin.micMixArray = ...
                    db2mag(...
                        [plugin.gainMains, ...
                        plugin.gainFlanks,...
                        plugin.gainCenter]);
                plugin.micPanArray = ...
                    [calculatePairWidth(plugin.mainsWidth),...
                    calculatePairWidth(plugin.flanksWidth)];
                plugin.lpCalcFlag = 0;    
            end
            % Get final mixdown scalars
            if plugin.mixCalcFlag == 1
                plugin.micOutputScalars = ...
                    getMicArrayStereoOutputScalars(plugin.micScalarArray,...
                    plugin.micPanArray,...
                    plugin.micMixArray,...
                    plugin.dampingScalars);
            end
            % Audio processing
            delayOut = plugin.delayLine([in in in in in], plugin.micTimeArray); % Delayline I/O
            scaleOut = mixdown(delayOut, plugin.micOutputScalars); % Apply the scalars
            % Output
            out = scaleOut;
        end
        % ------ Properties setters ------
        % All the setters!!!
        function set.mainsSplay(plugin, val)
            plugin.mainsSplay = val;
            plugin.recalcFlag = 1; % This consistently raises a warning, but it shouldn't (?) be a problem...
        end
        function set.flanksSplay(plugin, val)
            plugin.flanksSplay = val;
            plugin.recalcFlag = 1;
        end
        function set.mainsDistance(plugin, val)
            plugin.mainsDistance = val;
            plugin.recalcFlag = 1;
        end
        function set.flanksDistance(plugin, val)
            plugin.flanksDistance = val;
            plugin.recalcFlag = 1;
        end
        function set.centerDistance(plugin, val)
            plugin.centerDistance = val;
            plugin.recalcFlag = 1;
        end
        function set.pMains(plugin, val)
            plugin.pMains = val;
            plugin.recalcFlag = 1;
        end
        function set.pFlanks(plugin, val)
            plugin.pFlanks = val;
            plugin.recalcFlag = 1;
        end
        function set.pCenter(plugin, val)
            plugin.pCenter = val;
            plugin.recalcFlag = 1;
        end
        function set.gainMains(plugin, val)
            plugin.gainMains = val;
            plugin.lpCalcFlag = 1;
        end
        function set.gainFlanks(plugin, val)
            plugin.gainFlanks = val;
            plugin.lpCalcFlag = 1;
        end
        function set.gainCenter(plugin, val)
            plugin.gainCenter = val;
            plugin.lpCalcFlag = 1;
        end
        function set.useMains(plugin, val)
            plugin.useMains = val;
            plugin.recalcFlag = 1;
        end
        function set.useFlanks(plugin, val)
            plugin.useFlanks = val;
            plugin.recalcFlag = 1;
        end
        function set.useCenter(plugin, val)
            plugin.useCenter = val;
            plugin.recalcFlag = 1;
        end
        function set.useDistCompensation(plugin, val)
            plugin.useDistCompensation = val;
            plugin.recalcFlag = 1;
        end
        function set.speedOfSoundTrim(plugin, val)
            plugin.speedOfSoundTrim = val;
            plugin.recalcFlag = 1;
        end
        function set.levelAdjustmentEnum(plugin, val)
            plugin.levelAdjustmentEnum = val;
            plugin.mixCalcFlag = 1;
        end
        function set.levelAdjStrengthEnum(plugin, val)
            plugin.levelAdjStrengthEnum = val;
            plugin.mixCalcFlag = 1;
        end
        function set.sourceAngle(plugin, val)
            plugin.sourceAngle = val;
            plugin.recalcFlag = 1;
        end
        function set.sourceDistance(plugin, val)
            plugin.sourceDistance = val;
            plugin.recalcFlag = 1;
        end
        function set.mainsWidth(plugin, val)
            plugin.mainsWidth = val;
            plugin.lpCalcFlag = 1;
        end
        function set.flanksWidth(plugin, val)
            plugin.flanksWidth = val;
            plugin.lpCalcFlag = 1;
        end
        function array = get.mDistArray(plugin)
            array = [plugin.mainsDistance, plugin.flanksDistance, plugin.centerDistance];
        end
        function array = get.mSplayArray(plugin)
            array = [plugin.mainsSplay, plugin.flanksSplay];
        end
        function array = get.mPArray(plugin)
            array = [plugin.pMains, plugin.pFlanks, plugin.pCenter];
        end
        function array = get.mEnabledArray(plugin)
            array = [plugin.useMains, plugin.useFlanks, plugin.useCenter];
        end
        function pos = get.sourcePos(plugin)
            pos = sourceCartesianCoordinates(plugin.sourceAngle, plugin.sourceDistance);
        end
        function sos = get.speedOfSound(plugin)
            sos = plugin.c + plugin.speedOfSoundTrim;
        end
        % ------ Reset -----
        function reset(plugin) % The reset function for the plugin.
            plugin.recalcFlag = 1; % Set the plugin to recalculate information
            plugin.lpCalcFlag = 1;
            plugin.mixCalcFlag = 1;
            plugin.sampleRate = getSampleRate(plugin); % Get the sample rate
            reset(plugin.delayLine); % Reinitialise the delay line            
        end
    end
end


        