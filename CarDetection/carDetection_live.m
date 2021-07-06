function carDetection_live()
% 라즈베리파이와 웹캠 연결시키기
r=raspi(); %라즈베리파이를 사용할 때 사용
wcam = webcam(r,2); %라즈베리파이를 사용할 때 사용
%wcam = webcam(); %노트북에 웹캠을 직접 연결하여 사용할 때 : 영상이 더 선명함
%wcam.Resolution = wcam.AvailableResolutions{1}; %노트북에 웹캠을 직접 연결하여 사용할 때 : 영상이 더 선명함
viewer = vision.DeployableVideoPlayer();
% Auxiliary variables
fps = 0;
avgfps = [];
cont = true;
% 315장의 자동차 사진을 통해 학습시킨 탐지기 파일 로드
%load yoloCar.mat
detector='yoloCar.mat';
while cont
    frame = snapshot(wcam);
    tic; 
    sz = size(frame);
    resz =[128 128];
    frame1 = imresize(frame, resz);
    % 학습된 검출기로 해당 물체 인식
    tic;
    [bbox, score, label] = detect(detector, frame1, 'Threshold', 0.6, 'ExecutionEnvironment', "cpu");

    newt = toc;

    fps = .9*fps + .1*(1/newt);
    avgfps = [avgfps, fps];
    bbox(:,1) = bbox(:,1)*sz(2)/resz(2);
    bbox(:,2) = bbox(:,2)*sz(1)/resz(1);
    bbox(:,3) = bbox(:,3)*sz(2)/resz(2);
    bbox(:,4) = bbox(:,4)*sz(1)/resz(1);
    num = numel(bbox(:,1));
    detectedImg = frame;
    annotation = [];
    color =[];
    bbox1 =[];
    
    if num > 0
        label = categorical(label);
        k=1;
        % 들어갈 주석과 박스처리 될 부분의 색을 지정
        for n=1:num
            if label(n) == 'car'
                annotation{k} = sprintf('%s: ( %f)', label(n), score(n));
                color{k} = 'yellow';
                bbox1(k,:) = bbox(n,:);
                k=k+1;
            end
        end
         % 추가된 주석으로 결과를 표시
        detectedImg = insertObjectAnnotation(detectedImg, 'rectangle', bbox1, annotation,'Color',color);   
    end
    % 결과 출력
    detectedImg = insertText(detectedImg, [1, 1],  sprintf('FPS %2.2f', fps), 'FontSize', 26, 'BoxColor', 'y');    
   
    viewer(detectedImg)
    cont = isOpen(viewer);
end
release(viewer)