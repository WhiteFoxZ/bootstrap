package com.bootstrap.main;

import java.util.HashMap;
import java.util.List;

import com.bootstrap.service.TbCefEaf0100Service;

public class MyBatisTestApp {

	public static void main(String[] args) {

		TbCefEaf0100Service tbCefEaf0100Service = new TbCefEaf0100Service();

		insertDB(tbCefEaf0100Service);
		selectDB(tbCefEaf0100Service);


	}


	public static void selectDB(TbCefEaf0100Service tbCefEaf0100Service) {


		HashMap paramMap = new HashMap();
		paramMap.put("1", "1111");
		paramMap.put("2", "2222");

		List<HashMap> tbCefEaf0100s = tbCefEaf0100Service.getTbCefEaf0100ByIdForMap2(paramMap);

		if (tbCefEaf0100s != null)
			for (HashMap tbCefEaf0100 : tbCefEaf0100s) {
				System.out.println(tbCefEaf0100);
			}

		tbCefEaf0100Service.close();

		long heapSize = Runtime.getRuntime().totalMemory();
		System.out.println("Heap Size : " + heapSize);
		System.out.println("Heap Size(M) : " + heapSize / (1024 * 1024) + " MB");




	}

	public static void insertDB(TbCefEaf0100Service tbCefEaf0100Service) {

		HashMap insertMap = new HashMap();
		insertMap.put("CD_GROUP_ID", "testggg");
		insertMap.put("CD_GROUP_NM", "testggg");
		insertMap.put("CD_ID", "3333");
		insertMap.put("CD_MEANING", "3333");
		insertMap.put("LOGIN_ID", "test");

		tbCefEaf0100Service.insertTbCefEaf0100(insertMap);



	}

}
