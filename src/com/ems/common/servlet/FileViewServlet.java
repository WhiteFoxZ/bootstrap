package com.ems.common.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.util.EmsHashtable;
import com.google.gson.Gson;
import com.mysql.jdbc.Statement;

/**
 * 요청정보 및 파일정보를 JSON형태로 응답.
 */
public class FileViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {				
		
		String PK_IMG = request.getParameter("PK_IMG");
		String TNAME = request.getParameter("TNAME");
		
		
		PrintWriter out = response.getWriter();
		
		
		if(PK_IMG!=null && TNAME!=null){
			
			System.out.print("FileViewServlet ------------------");

			request.setCharacterEncoding("UTF-8");

			if (request.getHeader("accept").indexOf("application/json") != -1) {
				response.setContentType("application/json; charset=UTF-8");
			} else {
				// IE workaround
				response.setContentType("text/plain; charset=UTF-8");
			}

			

			RequestModel model = new RequestModel();
			
			DataSource ds = (DataSource) this.getServletContext().getAttribute("jdbc/mysql_ds");

			DBManager dbm = new DBManager(ds);
			
			EmsHashtable[] hash = null;
			
			ArrayList<FileInfoModel> photo = new ArrayList<FileInfoModel>();
			
			FileInfoModel fileInfo=null;

			try {
				
				hash = dbm.selectMultipleRecord("select * from all_img_info where TABLE_NAME=? and TABLE_KEY=? "
						, new String[]{TNAME,PK_IMG});
				
				//String name, String fileName, String uploadedFileName,
				//long fileSize, String contentType
				
				if(hash!=null)
				for(int i=0; i<hash.length; i++){
					
					fileInfo = new FileInfoModel("photo",
							hash[i].getString("FILE_NAME"),
							hash[i].getString("AUTO_KEY"),
							Long.parseLong(hash[i].getString("FILE_SIZE")),
							hash[i].getString("CONTENT_TYPE")						
					);
					
					photo.add(fileInfo);
									
				}
				
				model.setPhoto(photo);
				
				// 값 객체(VO,DTO)를 JSON형태로 문자열로 변환하기 위핸 Gson객체 생성.
				Gson gson = new Gson();
				String outString = gson.toJson(model);
				System.out.println(outString);
				out.print(outString);

			} catch (Exception e) {

				e.printStackTrace();

				out.print("{\"result\":\"500\"");
				out.print(",\"msg\":\"" + e.getMessage());
				out.print("\"}");
			}
			
			
		}else{
			
			out.print("{\"result\":\"500\"");
			out.print(",\"msg\":\"PK_IMG NULL\"");
			out.print("\"}");
		}
		
		
		
		
	}

	
	
	
	public static void main(String[] arg){
		
		
		System.out.println(System.currentTimeMillis() + UUID.randomUUID().toString());
	}

}