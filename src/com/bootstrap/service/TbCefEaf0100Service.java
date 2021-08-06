package com.bootstrap.service;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.bootstrap.mappers.TbCefEaf0100Mapper;
import com.bootstrap.util.MyBatisUtil;

public class TbCefEaf0100Service {

	SqlSession sqlSession = null;

	public TbCefEaf0100Service() {
		sqlSession = MyBatisUtil.getSqlSessionFactory().openSession();
		;
	}

	public HashMap getTbCefEaf0100ByIdForMap(String tapNo) {

		TbCefEaf0100Mapper TbCefEaf0100Mapper = sqlSession.getMapper(TbCefEaf0100Mapper.class);
		return TbCefEaf0100Mapper.getTbCefEaf0100ByIdForMap(tapNo);

	}

	public List<HashMap> getTbCefEaf0100ByIdForMap2(HashMap map) {

		TbCefEaf0100Mapper tbCefEaf0100Mapper = sqlSession.getMapper(TbCefEaf0100Mapper.class);

		return tbCefEaf0100Mapper.getTbCefEaf0100ByIdForMap2(map);

	}

	public void insertTbCefEaf0100(HashMap insertMap) {

		try {

//            TbCefEaf0100Mapper TbCefEaf0100Mapper = sqlSession
//                    .getMapper(TbCefEaf0100Mapper.class);
//
//            TbCefEaf0100Mapper.insertTbCefEaf0100(insertMap);

			sqlSession.insert("insertTbCefEaf0100", insertMap);

			sqlSession.commit();

		} catch (Exception e) {
			sqlSession.rollback();
		}

	}

	public void close() {
		if (sqlSession != null)
			sqlSession.close();
	}

}
