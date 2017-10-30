package cn.ql.service.impl;

import cn.ql.dao.ITms_dicDAO;
import cn.ql.entity.Tms_dic;
import cn.ql.service.ITms_dicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 123 on 2017/09/27.
 */
@Service("Tms_dicService")
public class ITms_dicServiceImpl implements ITms_dicService {

    @Resource(name = "ITms_dicDAO")
    private ITms_dicDAO ITms_dicDAO;

    public List<Tms_dic> getTeacherList(Map<String, Object> map) {
        return ITms_dicDAO.getTeacherList(map);
    }

    public List<Tms_dic> getWeekList() {
        return ITms_dicDAO.getWeekList();
    }

    public List<Tms_dic> getAMorPMList() {
        return ITms_dicDAO.getAMorPMList();
    }
}
