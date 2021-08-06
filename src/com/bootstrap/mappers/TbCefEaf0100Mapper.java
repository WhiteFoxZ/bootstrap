package com.bootstrap.mappers;

import java.util.HashMap;
import java.util.List;

import com.bootstrap.domain.TbCefEaf0100;

public interface TbCefEaf0100Mapper {

	public List<TbCefEaf0100> getTbCefEaf0100(String tapNo);

    public List<TbCefEaf0100> getAllTbCefEaf0100s();

    public HashMap getTbCefEaf0100ByIdForMap(String tapNo);

    public List<HashMap> getTbCefEaf0100ByIdForMap2(HashMap map);

    public void insertTbCefEaf0100(HashMap map);

}
