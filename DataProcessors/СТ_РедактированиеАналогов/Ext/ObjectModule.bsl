﻿Функция ДобавитьИзменитьЗапись(Номенклатура,Аналог,Действует)экспорт
	
	Период =  НачалоДня(ТекущаяДата());
	
	Набор = РегистрыСведений.СТ_Аналоги.СоздатьНаборЗаписей();
	Набор.Отбор.Период.Установить(Период);
	Набор.Отбор.Номенклатура.Установить(Номенклатура);
	Набор.Отбор.Аналог.Установить(Аналог);
	
	Набор.Прочитать();
	Набор.Очистить();	
	
	Запись = Набор.Добавить();
	Запись.Период				= Период;
	Запись.Номенклатура 		= Номенклатура;
	Запись.Аналог   			= Аналог;
	Запись.АналогДляПоиска		= СТ_Общий.ПодготовитьСтроку(Аналог);
	Запись.Действует 			= Действует;
	Запись.Ответственный		= ПараметрыСеанса.ТекущийПользователь;
	
	Набор.Записать(Истина);

	
КонецФункции


Функция ПолучитьМассивАналогов(Номенклатура) Экспорт
	
	Результ = Новый Массив;
	
	Отбор = Новый Структура("Номенклатура");
	Отбор.Номенклатура = Номенклатура; 

	Выборка = РегистрыСведений.СТ_Аналоги.СрезПоследних(,Отбор);	
	Для Каждого Стр Из  Выборка Цикл
		Если Стр.Действует Тогда
			Результ.Добавить(СокрЛП(Стр.Аналог));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результ;                            
КонецФункции