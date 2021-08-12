package com.ems.common.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;

/**
 * mysql db 에서 부터 가져와서 파일 다운로드
 * Servlet implementation class FileDownServlet
 */
public class FileDownloadServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, UnsupportedEncodingException,IOException {
		
		
		
		String key = request.getParameter("PK_IMG");
		

		if (key != null) {
			
			
			System.out.println("key "+key);

			ServletOutputStream out;
			out = response.getOutputStream();

			DataSource ds = (DataSource) this.getServletContext().getAttribute("jdbc/mysql_ds");

			DBManager dbm = new DBManager(ds);

			Connection con = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			InputStream is = null;

			String FILE_NAME = null;
			String CONTENT_TYPE = null;
			int FILE_SIZE = 0;

			try {
				
				con = dbm.getConnection();

				ps = con.prepareStatement("SELECT * FROM all_img_info WHERE AUTO_KEY=? ");

				ps.setString(1, key);

				rs = ps.executeQuery();

				if (rs.first()) {
					
					
					
					FILE_NAME = rs.getString("FILE_NAME");
					CONTENT_TYPE = rs.getString("CONTENT_TYPE");
					FILE_SIZE = rs.getInt("FILE_SIZE");
					is = rs.getBinaryStream("FILE");
					

					
					//웹브라우저가 파일을 다운로드 받로록 하려면 다음과 같이 컨테츠타입지정
					response.setContentType("application/octet-stream");					//					
					response.setContentLength(FILE_SIZE);//콘텐트 크기 지정
					//Content-Disposition헤더를 이용해서 전송되는 파일의 이름을 명시
					response.setHeader("Content-Disposition", "attachment; filename=\""+ FILE_NAME +"\"");					
					//전송되는 데이터의 인코딩이 바이너리 타입이라는것을 명시
					response.setHeader("Content-Transfer-Encoding","binary");
					response.setHeader("Pragma",  "no-cache;");
					response.setHeader("Expires", "-1;");
					
					System.out.println("buff 로 읽기");

					BufferedInputStream bin = new BufferedInputStream(is);
					BufferedOutputStream bout = new BufferedOutputStream(out);
					
					byte[] buf = new byte[1024];
					
					int ch = 0;
					
					while ((ch = bin.read(buf)) != -1) {
						bout.write(buf,0,buf.length);
					}
					

					bin.close();
					is.close();
					bout.close();
					out.close();
					
				
				}

			} catch (Exception e) {

				System.out.println(e);

			} finally {
				
				try {
					rs.close();
					ps.close();
					con.close();
				} catch (Exception e1) {
					e1.printStackTrace();

				}

			}

		}
		
	}
}
