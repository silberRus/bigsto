﻿

Процедура ВыполнитьЗагрузкуДанныхИзВременногоХранилища(Отказ, АдресВременногоХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xls");
	
	// получаем файл для считывания
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
		
КонецПроцедуры

Процедура ЗагрузитьОстаткиТоваров() Экспорт
	//Пытаемся подключиться к Excel
	Попытка
		Excel = новый COMОбъект("Excel.Application");
	Исключение
		Сообщить("Похоже, Excel на компьютере не установлен. Необходимо выполнить установку/переустановку Excel.");
		Возврат;
	КонецПопытки; 
	
	//Подключились удачно, открываем файл
	Excel.Workbooks.Open(ИмяВременногоФайла);
	
	//Открываем необходимый лист
	НомерЛиста = 1;
	Excel.Sheets(НомерЛиста).select();  
	
	
	//Получим количество строк и колонок.
	//В разных версиях Excel получаются по-разному, поэтому сначала определим версию Excel
	Версия = Лев(Excel.Version,Найти(Excel.Version,".")-1);
	Если Версия = "8" тогда
		ФайлСтрок   = Excel.Cells.CurrentRegion.Rows.Count;
		ФайлКолонок = Макс(Excel.Cells.CurrentRegion.Columns.Count, 13);
	Иначе
		ФайлСтрок   = Excel.Cells(1,1).SpecialCells(11).Row;
		ФайлКолонок = Excel.Cells(1,1).SpecialCells(11).Column;   
	Конецесли;
	
	//Тут пишем сам алгоритм загрузки
	/////////////////////
	////////////////////
	///////////////////
	//////////////////
	/////////////////
	
	
	
	
	
	//Отключаемся от Excel
	Excel.ActiveWorkbook.Close();
	
	//удаляем временный файл
	УдалитьВременныйФайл();
	
КонецПроцедуры

Процедура УдалитьВременныйФайл()
	
	Попытка
		
		Если Не ПустаяСтрока(ИмяВременногоФайла) Тогда
			
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

