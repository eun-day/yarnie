#!/usr/bin/env python3
"""
스플래시 화면용 아이콘 생성 스크립트
PIL(Pillow)을 사용하여 간단한 실뭉치 아이콘과 텍스트를 생성합니다.
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_yarn_icon():
    """실뭉치 아이콘 생성"""
    # 192x192 크기의 투명 배경 이미지 생성
    size = 192
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 실뭉치 색상 (딥 퍼플)
    yarn_color = (103, 58, 183, 255)  # #673AB7
    yarn_light = (149, 117, 205, 255)  # 밝은 퍼플
    
    # 실뭉치 본체 (원)
    center = size // 2
    radius = 60
    draw.ellipse([center-radius, center-radius, center+radius, center+radius], 
                 fill=yarn_color, outline=yarn_light, width=3)
    
    # 실 텍스처 라인들
    for i in range(-40, 41, 15):
        # 가로 라인
        y = center + i
        if center - radius < y < center + radius:
            x_offset = int((radius**2 - i**2)**0.5 * 0.8)
            draw.line([center-x_offset, y, center+x_offset, y], 
                     fill=yarn_light, width=2)
    
    # 실 끝부분 (곡선)
    draw.arc([center-radius-10, center-radius-10, center+radius+10, center+radius+10],
             start=45, end=135, fill=yarn_light, width=4)
    
    return img

def create_yarnie_text():
    """Yarnie 텍스트 이미지 생성"""
    # 텍스트 크기 계산
    width, height = 300, 80
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 텍스트 색상
    text_color = (255, 255, 255, 255)  # 흰색
    
    try:
        # 시스템 폰트 사용 시도
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 48)
    except:
        # 기본 폰트 사용
        font = ImageFont.load_default()
    
    # 텍스트 그리기
    text = "Yarnie"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (width - text_width) // 2
    y = (height - text_height) // 2
    
    draw.text((x, y), text, fill=text_color, font=font)
    
    return img

def main():
    """메인 함수"""
    # 아이콘 생성 및 저장
    yarn_icon = create_yarn_icon()
    yarn_icon.save('assets/splash/yarn_icon.png', 'PNG')
    print("✓ yarn_icon.png 생성 완료")
    
    # 텍스트 이미지 생성 및 저장
    yarnie_text = create_yarnie_text()
    yarnie_text.save('assets/splash/yarnie_text.png', 'PNG')
    print("✓ yarnie_text.png 생성 완료")
    
    print("스플래시 화면용 이미지 생성이 완료되었습니다!")

if __name__ == "__main__":
    main()