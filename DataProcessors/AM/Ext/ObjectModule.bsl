﻿

Функция ВыполнитьЗапрос(НаименованиеФункции,ТаблицаПараметров,СтрокаОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(НаименованиеФункции) Тогда
		СтрокаОшибки = "Не указана функция для запроса";
		Возврат Неопределено;
	КонецЕсли;
	
	Если Найти(НаименованиеФункции,":")=0 Тогда
		КомандаЗапроса=НаименованиеФункции+":";
	Иначе
		// Для совместимости с тестовыми вызовами
		КомандаЗапроса = НаименованиеФункции;
	КонецЕсли;
	Для Каждого Параметр Из ТаблицаПараметров Цикл
		Если ТипЗнч(Параметр.ЗначениеПараметра) = Тип("Число") Тогда
			КомандаЗапроса = КомандаЗапроса+Параметр.ИмяПараметра+"="+Формат(Параметр.ЗначениеПараметра,"ЧН=; ЧГ=0")+"|";
		Иначе
			КомандаЗапроса = КомандаЗапроса+Параметр.ИмяПараметра+"="+?(ЗначениеЗаполнено(Параметр.ЗначениеПараметра),СокрЛП(Параметр.ЗначениеПараметра),"")+"|";
		КонецЕсли;
	КонецЦикла;
	
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");

	WinHttp.Option(2,"UTF-8");
	
	//Если Константы.LaximoАвторизацияПоСертификату.Получить() = Ложь Тогда
		//ЛогинLaximo = СокрЛП(ПараметрыСеанса.Пользователь.ЛогинLaximo);
		//ПарольLaximo = СокрЛП(ПараметрыСеанса.Пользователь.ПарольLaximo);
		ЛогинLaximo = АТ_Кэш.ЛогинЛаксимо();
		ПарольLaximo = АТ_Кэш.ПарольЛаксимо();
		Если Не ЗначениеЗаполнено(ЛогинLaximo) Тогда
			СтрокаОшибки = "Не указан логин для доступа к Laximo.AM";
			Возврат Неопределено;
		КонецЕсли;
		ОбработкаMd5 = Обработки.MD5.Создать();
		Хэш = НРег(ОбработкаMd5.РасчетХЭШ(КомандаЗапроса+ПарольLaximo));
		ТекстЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
			|<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""
			|	xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""
			|	xmlns:xsd=""http://www.w3.org/2001/XMLSchema""
			|	xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
			|	xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/"">
			|	<SOAP-ENV:Body><ns5692:QueryDataLogin xmlns:ns5692=""http://Aftermarket.Kito.ec""><request xsi:type=""xsd:string"">ТелоЗапроса</request><login xsi:type=""xsd:string"">"+ЛогинLaximo+"</login><hmac xsi:type=""xsd:string"">хэш</hmac></ns5692:QueryDataLogin></SOAP-ENV:Body>
			|</SOAP-ENV:Envelope>";
		ТекстЗапроса=СтрЗаменить(ТекстЗапроса,"хэш",Хэш);
		ИмяДанных = "QueryDataLoginResponse";
		WinHttp.Open("POST", "http://aws.laximo.net/ec.Kito.Aftermarket/services/Catalog.CatalogHttpSoap11Endpoint/", 0);
	//Иначе
	//	ТекстЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	//		|<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""
	//		|	xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""
	//		|	xmlns:xsd=""http://www.w3.org/2001/XMLSchema""
	//		|	xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
	//		|	xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/"">
	//		|	<SOAP-ENV:Body><ns5692:QueryData xmlns:ns5692=""http://Aftermarket.Kito.ec""><request xsi:type=""xsd:string"">ТелоЗапроса</request></ns5692:QueryData></SOAP-ENV:Body>
	//		|</SOAP-ENV:Envelope>";
	//	ИмяДанных = "QueryDataResponse";
	//	ПутьКСертификату = Константы.LaximoСертификат.Получить();
	//	Если Не ЗначениеЗаполнено(ПутьКСертификату) Тогда
	//		СтрокаОшибки = "Не указан сертификат для доступа к Laximo.AM";
	//		Возврат Неопределено;
	//	КонецЕсли;
	//	WinHttp.Open("POST", "https://aws.laximo.net/ec.Kito.Aftermarket/services/Catalog.CatalogHttpSoap11Endpoint/", 0);
	//	WinHttp.SetClientCertificate("CURRENT_USER\MY\"+ПутьКСертификату);
	//КонецЕсли;
	
	
	
	WinHttp.SetRequestHeader("Accept", "*/*");
	WinHttp.setRequestHeader("Content-Type","text/xml; charset=UTF-8");   
	WinHttp.setRequestHeader("SOAPAction", """http://Aftermarket.Kito.ec"""); 

    ТекстЗапроса=СтрЗаменить(ТекстЗапроса,"ТелоЗапроса",КомандаЗапроса);

	WinHttp.Send(ТекстЗапроса);
	
	//Проверка ответа и его обработка
	Если WinHttp.Status <> 200 Тогда			//Если не ОК
		Если WinHttp.Status = 500 Тогда
			ПотокXML = Новый ЧтениеXML;
			XDTO	 = Новый ФабрикаXDTO;
			ПотокXML.УстановитьСтроку(WinHttp.ResponseText);
			СтрокаОшибки = lxОбщий.РазобратьОшибку500(XDTO.ПрочитатьXML(ПотокXML).Body.fault.faultstring);
			СтрокаОшибки = "Код - "+WinHttp.Status +" " + СтрокаОшибки;
			ПотокXML.Close();
		Иначе
			СтрокаОшибки = "Код - "+WinHttp.Status + Символы.ПС + "Статус текст - "+WinHttp.StatusText +Символы.ПС + "Ответ сервера - "+WinHttp.ResponseText;
		КонецЕсли;
		ЗаписьЖурналаРегистрации("Laximo.AM",УровеньЖурналаРегистрации.Ошибка,,СтрокаОшибки);
		WinHttp = Неопределено;
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаОтвета = WinHttp.ResponseText;
	СтрокаОшибки = "";
	WinHttp = Неопределено;
	
	ПотокXML = Новый ЧтениеXML;
	XDTO	 = Новый ФабрикаXDTO;
	Чтение   = Новый ЧтениеXML;
	ПотокXML.УстановитьСтроку(СтрокаОтвета);
	Чтение.УстановитьСтроку(XDTO.ПрочитатьXML(ПотокXML).Body[ИмяДанных].return);
	ОбъектXDTO  = XDTO.ПрочитатьXML(Чтение);
	Чтение.Закрыть();
	ПотокXML.Close();
	
	Возврат ОбъектXDTO;
	
КонецФункции


Процедура ПрочитатьReplacements(Док,Докdetailid)
	Если ТипЗнч(Док) = Тип("ОбъектXDTO") Тогда
		Если Док.Свойства().Получить("replacement") <> Неопределено Тогда
			Если ТипЗнч(Док.replacement) = Тип("ОбъектXDTO") Тогда
				Док2 = Док.replacement;
				СтрокаДанных = crosses.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
				ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2.detail);
				СтрокаДанных.detailid = Докdetailid;
				СтрокаДанных.replacementdetailid = Док2.detail.detailid;
				Если Не ЗначениеЗаполнено(СтрокаДанных.oem) Тогда
					СтрокаДанных.oem = lxОбщий.ОчиститьАртикул(СтрокаДанных.formattedoem);
				КонецЕсли;
			ИначеЕсли ТипЗнч(Док.replacement) = Тип("СписокXDTO") Тогда
				Доки2 = Док.ПолучитьСписок("replacement");
				Для Каждого Док2 Из Доки2 Цикл
					СтрокаДанных = crosses.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
					ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2.detail);
					СтрокаДанных.detailid = Докdetailid;
					СтрокаДанных.replacementdetailid = Док2.detail.detailid;
					Если Не ЗначениеЗаполнено(СтрокаДанных.oem) Тогда
						СтрокаДанных.oem = lxОбщий.ОчиститьАртикул(СтрокаДанных.formattedoem);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПрочитатьProperties(Док,Докdetailid)
	Если ТипЗнч(Док) = Тип("ОбъектXDTO") Тогда
		Если Док.Свойства().Получить("Property") <> Неопределено Тогда
			Если ТипЗнч(Док.Property) = Тип("ОбъектXDTO") Тогда
				Док2 = Док.Property;
				СтрокаДанных = Properties.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
				СтрокаДанных.detailid = Докdetailid;
			ИначеЕсли ТипЗнч(Док.Property) = Тип("СписокXDTO") Тогда
				Доки2 = Док.ПолучитьСписок("Property");
				Для Каждого Док2 Из Доки2 Цикл
					СтрокаДанных = Properties.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
					СтрокаДанных.detailid = Докdetailid;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПрочитатьImages(Док,Докdetailid)
	Если ТипЗнч(Док) = Тип("ОбъектXDTO") Тогда
		Если Док.Свойства().Получить("Image") <> Неопределено Тогда
			Если ТипЗнч(Док.Image) = Тип("ОбъектXDTO") Тогда
				Док2 = Док.Image;
				СтрокаДанных = Images.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
				СтрокаДанных.detailid = Докdetailid;
			ИначеЕсли ТипЗнч(Док.Image) = Тип("СписокXDTO") Тогда
				Доки2 = Док.ПолучитьСписок("Image");
				Для Каждого Док2 Из Доки2 Цикл
					СтрокаДанных = Images.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанных,Док2);
					СтрокаДанных.detailid = Докdetailid;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьИнформацию() Экспорт
	
	crosses.Очистить();
	Properties.Очистить();
	details.Очистить();
	Images.Очистить();
	
	ТаблицаП = Новый ТаблицаЗначений;
	ТаблицаП.Колонки.Добавить("ИмяПараметра");
	ТаблицаП.Колонки.Добавить("ЗначениеПараметра");
	Параметр = ТаблицаП.Добавить(); Параметр.ИмяПараметра = "Locale"; Параметр.ЗначениеПараметра = "ru_RU";
	Параметр = ТаблицаП.Добавить(); Параметр.ИмяПараметра = "Brand"; Параметр.ЗначениеПараметра = ""; //Параметр.ЗначениеПараметра = Производитель;
	Параметр = ТаблицаП.Добавить(); Параметр.ИмяПараметра = "OEM"; Параметр.ЗначениеПараметра = Артикул;
	СтрокаOptions = СРЕД(?(flag_crosses,",crosses","")+?(flag_images,",images","")+?(flag_names,",names","")+?(flag_properties,",properties","")+?(flag_weights,",weights",""),2);
	Параметр = ТаблицаП.Добавить(); Параметр.ИмяПараметра = "Options"; Параметр.ЗначениеПараметра = СтрокаOptions;
	Ошибки = "";
	Ответ = ВыполнитьЗапрос("FindOEM",ТаблицаП,Ошибки);
	Если Ответ = Ложь Тогда
		//Предупреждение("Ошибка вызова функции: "+Ошибки);     // Не доступен на сервере
		Сообщить("Ошибка вызова функции: "+Ошибки, СтатусСообщения.Важное);
		Возврат;
	ИначеЕсли Ответ = Неопределено Тогда
		// Просто молча уйдем )
		Возврат;
	КонецЕсли;
	
	Если Ответ.FindOEM.Свойства().Количество() > 0 Тогда
		ОбъектXDTO = Ответ.FindOEM;
	Иначе
		// просто ничего нет ))
		Возврат;
	КонецЕсли;
	
	Если ОбъектXDTO.Свойства().Получить("detail") <> Неопределено Тогда
		
		Если ТипЗнч(ОбъектXDTO.detail) = Тип("СписокXDTO") Тогда
			// Много документов
			Доки = ОбъектXDTO.ПолучитьСписок("detail");
			Для Каждого Док Из Доки Цикл
				СтрокаДанных = details.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанных,Док);
				ПрочитатьReplacements(Док.replacements,Док.detailid);
				ПрочитатьProperties(Док.Properties,Док.detailid);
				ПрочитатьImages(Док.Images,Док.detailid);
			КонецЦикла;
		ИначеЕсли ТипЗнч(ОбъектXDTO.detail) = Тип("ОбъектXDTO") Тогда
			// В свойстве один документ (row)
			Док = ОбъектXDTO.detail;
			СтрокаДанных = details.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанных,Док);
			ПрочитатьReplacements(Док.replacements,Док.detailid);
			ПрочитатьProperties(Док.Properties,Док.detailid);
			ПрочитатьImages(Док.Images,Док.detailid);
		Иначе
			СтрокаОшибки = "FindOEM: Неверный тип объекта";
			ЗаписьЖурналаРегистрации("Laximo.OEM",УровеньЖурналаРегистрации.Ошибка,,СтрокаОшибки);
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры




