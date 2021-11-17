package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    List<Contacts> getContactsListByName(String cname);

    int save(Contacts con);
}
