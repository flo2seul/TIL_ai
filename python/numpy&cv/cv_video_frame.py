import cv2
import os
cap = cv2.VideoCapture('./video/sample.mp4')
count = 0
interval = 10 # 10프레임마다 1장 저장
OUTPUT_PATH = os.path.join('./video','frames')
if not os.path.exists(OUTPUT_PATH):
    os.mkdir(OUTPUT_PATH)
subtractor = cv2.createBackgroundSubtractorMOG2(history=500, varThreshold=50,detectShadows=True)
while True:
    ret, frame = cap.read()
    if not ret:
        break
    mask = subtractor.apply(frame)
    cv2.imshow('orginal',frame)
    cv2.imshow('background mask', mask)
    if cv2.waitKey(30) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()
print('완료')