% 라즈베리파이 하드웨어에 연결된 웹캠에서 라이브 이미지를 획득하고, 획득한 이미지에서 에지 감지 기능을 수행해
% 동일한 라즈베리 파이 하드웨어에 연결된 결과를 모니터에 표시하는 방법을 배운다
function edgeDetection() %#codegen
% MATLAB이 하드웨어에 연결하고 하드웨어에 연결된 웹캠에서 캡처한 이미지에서 에지 감지 알고리즘을 실행하기 시작

% Rasperry Pi 하드웨어에 대한 연결
  r = raspi;
  
% Rasperry Pi 카메라 모듈에 대한 연결 생성, 라이브 캡처
% 영상 및 영상 표시
  w = webcam(r, 2);
% 에지 탐지에 사용할 컨볼루션 커널 정의
  kern = [1 2 1; 0 0 0; -1 -2 -1];
  
% Rasperry Pi 카메라 모듈에서 캡처한 이미지에서 에지 감지 알고리즘을 실행
for k = 1:300
img = snapshot(w);
h = conv2(img(:,:,2),kern,'same');
v = conv2(img(:,:,2),kern','same');
e = sqrt(h.*h + v.*v);
edgeImg = uint8((e > 100) * 240);
% 가장자리가 감지된 이미지를 원본 이미지와 결합하도록 확장한다.
newImg = cat(3,edgeImg,edgeImg,edgeImg);
% 결합된 이미지를 보여준다.
displayImage(r, newImg);
end
end

  