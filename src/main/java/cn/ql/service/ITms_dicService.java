package cn.ql.service;

import cn.ql.entity.Tms_dic;

import java.util.List;
import java.util.Map;

/**
 * Created by 123 on 2017/09/27.
 */

public interface ITms_dicService {
    public List<Tms_dic> getTeacherList(Map<String,Object> map);

    public List<Tms_dic> getWeekList();

    public List<Tms_dic> getAMorPMList();
}
