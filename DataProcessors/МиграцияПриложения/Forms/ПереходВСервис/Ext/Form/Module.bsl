﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	НастроитьЭлементы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
		ПодключитьОбработчикОжидания("ОбновлениеСтатусаПерехода", 60, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПараметры Тогда
		НачатьПереход();
		ПодключитьОбработчикОжидания("ОбновлениеСтатусаПерехода", 60, Ложь);
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат 
		Или Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка Тогда
		ОчиститьСостояниеВыгрузки();
		Закрыть();
	КонецЕсли;
	
	НастроитьЭлементы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОтменитьПереход();
	ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");

КонецПроцедуры

&НаСервере
Процедура НачатьПереход()
	
	МиграцияПриложений.НачатьВыгрузку(АдресПриложения, Логин, Пароль);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПереход()
	
	МиграцияПриложений.ОтменитьВыгрузку();
	
	ДатаЗавершения = ТекущаяУниверсальнаяДата();
	Результат = НСтр("ru = 'Переход в сервис отменен'");
	
	НастроитьЭлементы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементы(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Далее.Видимость = Ложь;
	Элементы.Отмена.Видимость = Ложь;
	
	Если Не ЗначениеЗаполнено(Форма.ДатаНачала) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПараметры;
		Элементы.Далее.Видимость = Истина;
		Элементы.Далее.Заголовок = НСтр("ru = 'Далее'");
	ИначеЕсли ЗначениеЗаполнено(Форма.ОписаниеОшибки) Тогда
		Элементы.Далее.Видимость = Истина;
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
	ИначеЕсли ЗначениеЗаполнено(Форма.ДатаЗавершения) Тогда
		Если ПустаяСтрока(Форма.Результат) Тогда
			Форма.Результат = НСтр("ru = 'Переход завершен.'");
		КонецЕсли;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		Элементы.Далее.Видимость = Истина;
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
		Элементы.Отмена.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СостояниеПерехода()
	
	СостояниеПерехода = МиграцияПриложений.СостояниеВыгрузки();
	СостояниеПерехода.Вставить("ОсталосьВремени", НСтр("ru = '<Неизвестно>'"));
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаНачала) 
		И Не ЗначениеЗаполнено(СостояниеПерехода.ДатаЗавершения)
		И СостояниеПерехода.ОбработаноСообщений >= 3 Тогда
		
		ОставшеесяВремя = (ТекущаяУниверсальнаяДата() - СостояниеПерехода.ДатаНачала) / СостояниеПерехода.ЗагруженоОбъектов * СостояниеПерехода.ЗагрузитьОбъектов;
		
		Если ОставшеесяВремя <= 180 Тогда
			СостояниеПерехода.ОсталосьВремени = НСтр("ru = 'Несколько минут'");
		ИначеЕсли ОставшеесяВремя <= 3600 Тогда
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 мин.'"), Окр(ОставшеесяВремя / 60));
		Иначе
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 ч.'"), Окр(ОставшеесяВремя / 3600, 1));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаНачала) Тогда
		СостояниеПерехода.ДатаНачала = МестноеВремя(СостояниеПерехода.ДатаНачала, ЧасовойПоясСеанса());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаЗавершения) Тогда
		СостояниеПерехода.ДатаЗавершения = МестноеВремя(СостояниеПерехода.ДатаЗавершения, ЧасовойПоясСеанса());
	КонецЕсли;
	
	СостояниеПерехода.Вставить("Прогресс", 0);
	Если СостояниеПерехода.ЗагруженоОбъектов <> 0 Тогда
		СостояниеПерехода.Вставить("Прогресс", СостояниеПерехода.ЗагруженоОбъектов * 100 / (СостояниеПерехода.ЗагрузитьОбъектов + СостояниеПерехода.ЗагруженоОбъектов));
	КонецЕсли;
	
	Возврат СостояниеПерехода;
	
КонецФункции

&НаКлиенте
Процедура ОбновлениеСтатусаПерехода()
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	Если ЗначениеЗаполнено(ДатаЗавершения) Тогда
		ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");
	КонецЕсли;
	
	НастроитьЭлементы(ЭтотОбъект);
	
КонецПроцедуры
	
&НаСервере
Процедура ОчиститьСостояниеВыгрузки()
	
	РегистрыСведений.МиграцияПриложенийСостояниеВыгрузки.СоздатьНаборЗаписей().Записать();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
КонецПроцедуры
