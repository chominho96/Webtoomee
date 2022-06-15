package com.example.image;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 *  파일 업로드를 위한 클래스입니다.
 */
public class UploadImage {

    /**
     *
     * 웹툰 썸네일을 저장하고, 저장한 파일 이름을 반환합니다.
     */
    public static String saveWebtoonThumbnail(Part part, HttpServletRequest request) {
        return saveFile(part, request.getSession().getServletContext(), "images");
    }

    /**
     *
     *  실제 저장 로직이 들어있는 함수입니다.
     *  Part 변수, context 변수, 경로 문자열을 받아서 "UUID_이름"을 저장하고, 저장된 이름을 반환합니다.
     */
    private static String saveFile(Part part, ServletContext context, String pathStr) {
        try {
            String fileName = part.getSubmittedFileName();
            String path = context.getRealPath(pathStr);

            if (fileName != null && fileName.length() != 0) {
                String savedFileName = UUID.randomUUID() + "_" + fileName;
                part.write(path + File.separator + savedFileName);
                return savedFileName;
            }
            else {
                return null;
            }
        }
        catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     *  특정 파일을 저장된 경로에서 삭제합니다.
     */
    public static void deleteFile(String fileName, ServletContext context, String pathStr) {
        String realPath = context.getRealPath(pathStr);
        File file = new File(realPath + File.separator + fileName);
        file.delete();
    }
}
