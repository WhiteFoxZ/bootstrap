package com.ems.common.servlet;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;

/**
 * mysql db 에서 부터 가져와서 파일 다운로드
 * Servlet implementation class FileDownServlet
 */
public class FileDeleteServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(FileDeleteServlet.class.getName());

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, UnsupportedEncodingException,IOException {

		System.out.println("FileDeleteServletFileDeleteServletFileDeleteServlet ");

		String key = request.getParameter("PK_IMG");


		if (key != null) {

			System.out.println("삭제 ");
			System.out.println("key "+key);

			ServletOutputStream out;
			out = response.getOutputStream();

			DataSource ds = (DataSource) this.getServletContext().getAttribute(
					"jdbc/mysql_ds");

			DBManager dbm = new DBManager(ds);

			Connection con = null;

			JSONObject outJson = new JSONObject();		//json 형태 데이터로 화면에 데이터를 전송하기 위해 사용


			try {

				con = dbm.getConnection();

				int i = dbm.delete(con,"DELETE FROM all_img_info WHERE AUTO_KEY=? ",new String[]{key});

				dbm.commitChange(con);

				if(i>0)
					outJson.put("event", "success");
				else
					outJson.put("event", "fail");

				log.debug(outJson.toString());

			} catch (Exception e) {

				System.out.println(e);

			} finally {


				out.print(outJson.toString());
				out.flush();
			}

		}

	}
}
