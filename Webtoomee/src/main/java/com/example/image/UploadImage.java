package com.example.image;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class UploadImage {
    public static String saveWebtoonThumbnail(Part part, HttpServletRequest request) {
        return saveFile(part, request.getSession().getServletContext(), "images");
    }
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

    public static void deleteFile(String fileName, ServletContext context, String pathStr) {
        String realPath = context.getRealPath(pathStr);
        File file = new File(realPath + File.separator + fileName);
        file.delete();
    }
}
