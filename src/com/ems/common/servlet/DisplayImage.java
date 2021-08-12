package com.ems.common.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;

/**
 * DB 에서 이미지를 가져와 화면에 보여준다. Servlet implementation class DisplayImage
 */
public class DisplayImage extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DisplayImage() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		String key = request.getParameter("PK_IMG");

		if (key != null) {
			
			
			System.out.println("key "+key);

			response.setContentType("image/jpeg");
			ServletOutputStream out;
			out = response.getOutputStream();

			DataSource ds = (DataSource) this.getServletContext().getAttribute(
					"jdbc/mysql_ds");

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

					System.out.println("FILE_NAME " + FILE_NAME);

					is = rs.getBinaryStream("FILE");

					BufferedInputStream bin = new BufferedInputStream(is);
					BufferedOutputStream bout = new BufferedOutputStream(out);
					int ch = 0;
					;
					while ((ch = bin.read()) != -1) {
						bout.write(ch);
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
