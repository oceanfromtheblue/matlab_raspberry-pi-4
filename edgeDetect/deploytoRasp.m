%% Configuration object for Raspberry Pi
board = targetHardware('Raspberry Pi');
board.CoderConfig.TargetLang = 'C++';
%% Configuration object for Deep Learning Code generation
dlcfg = coder.DeepLearningConfig('arm-compute');
dlcfg.ArmArchitecture = 'armv7';
dlcfg.ArmComputeVersion = '19.05';
%% asd
board.CoderConfig.DeepLearningConfig = dlcfg;
deploy(board, 'carDetection_live');