﻿
&НаКлиенте
Процедура ПолучитьAccessToken(Команда)
	
	ОповещениеПослеВвода = Новый ОписаниеОповещения("ООПолучитьAccessToken", ЭтотОбъект);
	ПоказатьВводСтроки(ОповещениеПослеВвода, , "Введите код авторизации для получения нового Токена", 36, Ложь); 
	
КонецПроцедуры

&НаКлиенте
Процедура ООПолучитьAccessToken(authorizationCode, ДополнительныеПараметры) Экспорт

	QWEP_Клиент.ПолучитьAccessToken(authorizationCode);
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОПриложении(Команда)
    
    ИнформацияОПриложенииТекст = QWEP_Клиент.ПолучитьИнформациюОПриложении();
    Сообщить(ИнформацияОПриложенииТекст);
    
КонецПроцедуры
