﻿
Функция ПолучитьИмяIPФайлаНаСервере() Экспорт
	
	Возврат "D:\passLog\ipSec.txt";	// - потом поменять на константу или настройку
	
КонецФункции
Функция ПолучитьIP4Сеанса()
	
	Массив 		= Новый Массив;
	strComputer = "."; 
	
	Попытка
		objWMIService = ПолучитьCOMОбъект("winmgmts:\\" + strComputer + "\root\CIMV2");
		colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE",,48);
	Исключение
		Перейти ~Возврат;
	КонецПопытки;
	
	Для Каждого objItem Из colItems Цикл 
		Для Каждого Стр Из objItem.IPAddress Цикл 
			Если СтрЧислоВхождений(стр, ".") = 3 Тогда
				Массив.Добавить(Стр);
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
	~Возврат:
	Возврат Массив;
	
КонецФункции
Процедура ЗаписатьIPПользователя() Экспорт
	
	// Пытается записать ip пользователей вызывающих сеанс
	// формат записи файла, каждая строка имя пользователя:
	//		<имя пользователя>:<его ip через точку с запятой>
	
	ИмяФайлаНаСервере = ПолучитьИмяIPФайлаНаСервере();
	
	ipАдреса = ПолучитьIP4Сеанса();
	Если ipАдреса.Количество() Тогда
		
		ОшибкаЧтения = Ложь;
		Текст = АТ_ОбщегоНазначения.ПолучитьТекст(ИмяФайлаНаСервере, ОшибкаЧтения);
		
		Если Не ОшибкаЧтения Тогда
			
			сис 		= Новый СистемнаяИнформация;
			Usr 		= АТ_Кэш.ИмяПользователяИБстр();
			ДобСтрока 	= СтрШаблон("%1: %2; Mozg: %3; OC:%4; processor:%5", Usr, СтрСоединить(ipАдреса, "; "), сис.ОперативнаяПамять, сис.ВерсияОС, сис.Процессор);
			ЧислоСтрок 	= СтрЧислоСтрок(Текст);
			НовСтроки	= Новый Массив;
			Добавить	= Истина;
			
			Если Не ПустаяСтрока(Текст) Тогда
				
				НомСтроки = 0;
				Для Ном = 1 По ЧислоСтрок Цикл
					
					текСтрока = СтрПолучитьСтроку(Текст, Ном);
					
					Если СтрНачинаетсяС(текСтрока, Usr) Тогда
						
						Если текСтрока = ДобСтрока Тогда
							Возврат; // ничего не изменилось нет смысла лишний раз записывать файл
						КонецЕсли;
						
						НовСтроки.Добавить(ДобСтрока);
						Добавить = Ложь;
						
					Иначе
						НовСтроки.Добавить(текСтрока);
					КонецЕсли;
					
				КонецЦикла;
			КонецЕсли;
			
			Если Добавить Тогда
				НовСтроки.Добавить(ДобСтрока);
			КонецЕсли;
			
			АТ_ОбщегоНазначения.ЗаписатьТекст(ИмяФайлаНаСервере, СтрСоединить(НовСтроки, Символы.ПС));
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
