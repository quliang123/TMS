package cn.ql.controller;

import cn.ql.entity.Sys_privilege;
import cn.ql.entity.Sys_userInfo;
import cn.ql.service.ISys_roleService;
import cn.ql.service.ISys_userInfoService;
import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by 123 on 2017/10/16.
 */
@Controller
public class UserController {
    Gson gson = new Gson();

    @Resource(name = "ISys_userInfoService")
    private ISys_userInfoService iSys_userInfoService;

    @Resource(name = "ISys_roleService")
    private ISys_roleService iSys_roleService;


    @Transactional(rollbackFor = Exception.class)
    @ResponseBody
    @RequestMapping("/savePrivilege")
    public String savePrivilege(Integer roleId, String funcIds) {

        int flag = 0;
        flag = iSys_userInfoService.delPrivilegeByUserId(roleId);
        System.out.println("flag" + flag);

        String[] str = funcIds.split(",");
        for (String item : str) {
            System.out.println(roleId + "=======" + item);
            flag = iSys_userInfoService.savePrivilege(roleId, Integer.valueOf(item));
            System.out.println("flag" + flag);
        }
        if (flag > 0) {
            return "1";
        } else {
            return "2";
        }
    }

    @ResponseBody
    @RequestMapping("/getUserByRid")
    public Object getUserListByRid(Integer rid) {
        List<Sys_userInfo> list = iSys_userInfoService.getUserListByRid(rid);
        return list;
    }


    @ResponseBody
    @RequestMapping("/userList")
    public Object getUserList(HttpServletRequest request, Integer page, Integer rows) {
        System.out.println(page + "====" + rows);

        Map<String, Object> map = null;
        if ((page != 0 || rows != 0)) {
            map = new HashMap<String, Object>();
            map.put("page", (page - 1) * rows);
            map.put("rows", rows);
        }
        Integer pageSize = iSys_userInfoService.getCount(map);
        List<Sys_userInfo> userInfoList = iSys_userInfoService.getUserInfoList(map);

        // Map<String, Object> maps = new HashMap<String, Object>();

        map.put("total", pageSize);
        map.put("rows", userInfoList);
        return map;
    }


    @ResponseBody
    @RequestMapping("/roleTree")
    public Object roleTree(Integer roleId) throws UnsupportedEncodingException {
        System.out.println("roleTree" + roleId);
        List<Sys_privilege> roleList = iSys_roleService.getRoleTreeByRoleId(roleId);
        List<Sys_privilege> privileges = iSys_roleService.getAllList();
        System.out.println("roleList" + roleList);
        System.out.println("privileges" + privileges);

        for (int i = 0; i < privileges.size(); i++) {           //全部权限集合
            Sys_privilege a = privileges.get(i);
            for (int j = 0; j < roleList.size(); j++) {         //用户所拥有的权限集合
                Sys_privilege b = roleList.get(j);
                System.out.println(a.getId() + "=======" + b.getParent());
                //if (a.getParent() == 0 && b.getParent() == 0) {   //
                if (a.getParent() == b.getParent()) {   //1 2 3  21  31  31  32   33
                    a.setChecked(true);
                    System.out.println(a.toString());
                    break;
                } else {
                    a.setChecked(false);
                    continue;
                }
                // }
            }
        }


        // System.out.println(privileges.toString());
        for (int i = 0; i < privileges.size(); i++) {
            Sys_privilege p1 = privileges.get(i);
            //System.out.println("privileges" + p1.getName());
            //continue;
            if (p1.getParent() == 0) {   // 1   2  3
                //System.out.println("p1.getName()" + p1.getName());
                for (int j = 0; j < privileges.size(); j++) {
                    Sys_privilege p2 = privileges.get(j);
                    if (p2.getParent() != 0) {
                        if (p1.getId() == p2.getParent()) {
                            p1.getChildren().add(privileges.get(j));
                            //System.out.println("privileges.get(j).getName()" + privileges.get(j).getName());
                            privileges.remove(j);
                            j -= 1;
                            //System.out.println(o);
                        } else {
                            continue;
                        }
                    } else {
                        continue;
                    }
                }
            } else {    //子节点
                for (int k = 0; k < privileges.size(); k++) {
                    Sys_privilege p3 = privileges.get(k);
                    p3.getChildren().add(p1);
                    if (p1.getId() == p3.getParent()) {
                        break;
                    }
                }
            }
        }


        String ret = gson.toJson(privileges);
        // System.out.println("ret" + ret);
        //ret = new String(ret.getBytes("iso-8859-1"), "UTF-8");

        ret = ret.replace("name", "text");
        //System.out.println("name" + ret);
        ret = ret.replace("parent", "pid");
        System.out.println("ret" + ret);
        return ret;
    }


    @ResponseBody
    @RequestMapping("/getList")
    public Object getListing() {
        return iSys_roleService.getListing();
    }

    @RequestMapping(value = "main")
    public String main(HttpServletRequest request) {
        Sys_userInfo user = (Sys_userInfo) request.getSession().getAttribute("user");
        List<Sys_privilege> sys_privilege = iSys_userInfoService.getPrivilegeByUid(user.getUid());
        List<Sys_privilege> rootMenus = new LinkedList<Sys_privilege>();
        for (Sys_privilege item : sys_privilege) {
            Sys_privilege childMenu = item;
            int pid = item.getParent();      //0 0  2  3
            if (pid == 0) {      //如果是根节点
                rootMenus.add(item);
            } else {          //否则是子节点的话
                for (Sys_privilege innerItem : sys_privilege) {
                    int id = innerItem.getId();
                    if (id == pid) {       // 2    3
                        Sys_privilege parentMenu = innerItem;
                        System.out.println(parentMenu.getChildren());
                        parentMenu.getChildren().add(childMenu);
                        break;
                    }
                }
            }
        }
        request.getSession().setAttribute("rootMenus", rootMenus);
        return "/main";
    }

    @ResponseBody
    @RequestMapping(value = "login")
    public String isLogin(HttpServletRequest request, String userName, String password) {
        System.out.println("登陆进来了" + userName + "====" + password);
        Sys_userInfo user = iSys_userInfoService.isLogin(userName, password);
        if (user == null) {
            return "n";
        }
        request.getSession().setAttribute("user", user);
        return "y";
    }

}
