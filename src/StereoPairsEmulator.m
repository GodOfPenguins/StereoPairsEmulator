classdef StereoPairsEmulator < audioPlugin
    %STEREOPAIRSEMULATOR Emulates the level and time differences of a
    %microphone array
    %   This plugin emulates the level and time cues of a microphone array.
    %   It takes in a mono input and outputs a stereo signal based on the
    %   virtual microphone set-up and the mixdown settings.
    
    properties
        % ------UI PROPERTIES-----
        % Angular splay values for the mic pairs
        mainsSplay; 
        flanksSplay
        % Distances for each pair of microphones
        % Note that the pairs distances are lateral, while the center
        % distance will be vertical,
        mainsDistance;
        flanksDistance; 
        centerDistance; % Distance forward, not lateral
        % Polar pattern values for the microphones
        % These will be a number from 0 to 1 where omni is 0 and
        % bidirectional is 1
        pMains;
        pFlanks;
        pCenter; % This could probably be the same as the main pair...
        % Gain adjustments
        gainMains;
        gainFlanks;
        gainCenter;
        % Toggles for pair use
        useMains;
        useFlanks;
        useCenter;
        % Distance compensation
        useDistCompensation;
        speedOfSoundTrim;
        % Level adjustment for the array
        levelAdjustmentEnum;
        levelAdjStrengthEnum;
        % Sound source properties
        sourceAngle;
        sourceDistance;   
    end
    properties
        sampleRate = 48000; % default sample rate
        delayLine;
        micScalarArray = [0 0 0 0 0];
        micTimeArray = [0 0 0 0 0];
    end
    properties(Dependent)
        recalcFlag;
        sourcePos;
        speedOfSound;
        mDistArray;
        mPArray;
        mSplayArray;
        mEnabledArray;
    end
    properties(Constant)
        PluginInterface = audioPluginInterface(...
            'PluginName','Stereo Pairs Emulator',...
            'VendorName','Fat Penguin Sound',...
            'VendorVersion', '0.0.3',...
            'InputChannels',1,...
            'OutputChannels',2,...
            audioPluginParameter('sourceAngle',...
                'DisplayName','Source Angle',...
                'Mapping',{'lin',-90,90},... % This will need to be flipped in calculations... also converted to radians.
                'Style','rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','�'),...
            audioPluginParameter('sourceDistnace',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,15},... % This is in meters -- controls the maximum distance the source can be away from the center of the main array
                'Style','rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','m'...
            ),...
            audioPluginParameter('mainsDistance',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,300},... % Distance between the main stereo pair. Needs to be converted to m for calculations.
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','cm'...
            ),...
            audioPluginParameter('flanksDistnace',...
            'DisplayName','Distance',...
                'Mapping',{'lin',0,10},... % Distance between the flanking stereo pair. This distance is in meters.
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','m'...
            ),...
            audioPluginParameter('centerDistance',...
                'DisplayName','Distance',...
                'Mapping',{'lin',0,200},... % Distance of the centre mic (forward). In cm and needs to be converted.
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','cm'...
            ),...
            audioPluginParameter('mainsSplay',...
                'DisplayName','Angle',...
                'Mapping',{'lin',0,180},... % Angle between the microphones in degrees
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','�'...
            ),...
            audioPluginParameter('flanksSplay',...
                'DisplayName','Angle',...
                'Mapping',{'lin',0,180},... % Angle between the microphones in degrees
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','�'...
            ),...
            audioPluginParameter('pMains',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... % We'll make this so that it increases directivity as it moves towards 1, that'll make more sense for the user
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('pFlanks',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... 
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('pCenter',...
                'DisplayName','Directivity',...
                'Mapping',{'lin',0,1},... 
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('gainMains',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},... % This range could be wider, but for mixing, this is probably the most realistically useful range. Any lower than -20 and the mics should just be turned off.
                'Style','vslider',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('gainFlanks',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},...
                'Style','vslider',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('gainCenter',...
                'DisplayName','Level',...
                'Mapping',{'pow',1/3,-20,0},...
                'Style','vslider',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','dB'...
            ),...
            audioPluginParameter('useMains',...
                'DisplayName','Mains',...
                'Style','vrocker',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('useFlanks',...
                'DisplayName','Flanks',...
                'Style','vrocker',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('useCenter',...
                'DisplayName','Centre',...
                'Style','vrocker',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('speedOfSoundTrim',...
                'DisplayName','Time Alignment',...
                'Mapping',{'lin',-10,10},... % Based on an estimate of temperture values on a concert hall, giving a range of speed of sound values for potential tempertures.
                'Style','Rotaryknob',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above',...
                'Label','m/s'...                
            ),...
            audioPluginParameter('useDistCompensation',...
                'DisplayName','Distance Compensation',...
                'Style','vrocker',...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginParameter('levelAdjustmentEnum',...
                'DisplayName','Level-Distance Compensation',...
                'Style','dropdown',...
                'Mapping',{'enum','None','Flanks Only','Pairwise','Full Array'},...
                'Layout',[1,1],...
                'DisplayNameLocation', 'Above'...
            ),...
            audioPluginParameter('levelAdjStrengthEnum',...
                'DisplayName','Level Adjustment Strength',...
                'Style','dropdown',...
                'Mapping',{'enum','-6','-3','-1.5'},...
                'Layout',[1,1],...
                'DisplayNameLocation','Above'...
            ),...
            audioPluginGridLayout( ...
                'RowHeight',[20, 100, 20, 20, 100, 20, 100, 20, 160],...
                'ColumnWidth',[50, 50, 50, 50, 100, 50, 50, 50, 50])...
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
                updateMicArray(plugin.mDistArray, plugin.mSplayArray, plugin.mPArray, plugin.sourcePos 
                mDistArray;
        mPArray;
        mSplayArray;
        mEnabledArray;
                
                plugin.recalcFlag = 0;
            end
            % Audio processing
            
            % Output
            out = in;
        end
        % ------ Properties setters ------
        % All the setters!!!
        function set.mainsSplay(plugin, val)
            plugin.mainSplay = val;
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
        end
        function set.gainFlanks(plugin, val)
            plugin.gainFlanks = val;
        end
        function set.gainCenter(plugin, val)
            plugin.gainCenter = val;
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
        end
        function set.levelAdjStrengthEnum(plugin, val)
            plugin.levelAdjStrengthEnum = val;
        end
        function set.sourceAngle(plugin, val)
            plugin.sourceAngle = val;
            plugin.recalcFlag = 1;
        end
        function set.sourceDistance(plugin, val)
            plugin.sourceDistance = val;
            plugin.recalcFlag = 1;
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
            plugin.sampleRate = getSampleRate(plugin); % Get the sample rate
            plugin.micScalarArray = [0 0 0 0 0]; % Should be unecessary, but to be safe
            plugin.micTimeArray = [0 0 0 0 0];
            reset(plugin.delayLine); % Reinitialise the delay line            
        end
    end
end