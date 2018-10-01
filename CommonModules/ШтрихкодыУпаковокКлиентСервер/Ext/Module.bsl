﻿#Область ПрограммныйИнтерфейс

// Возвращает уточненное описание типов значения идентификатора применения по базовому типу
// и значению дополнительного параметра
//
// Параметры:
// 	КлючИдентификатора - Строка - Код (ключ) идентификатора применения
// 	ДополнительныйПараметрЗначение - Число - Значение дополнительного параметра
//
// Возвращаемое значение:
// 	ОписаниеТипов - уточненное описание типов для значения идентификатора применения
//
Функция ТипЗначенияПараметра(КлючИдентификатора, ДополнительныйПараметрЗначение = 0) Экспорт
	
	СвойстваИдентификаторов = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
	СвойстваИдентификатора  = СвойстваИдентификаторов.Получить(КлючИдентификатора);
	
	БазовыйТип = СвойстваИдентификатора.БазовыйТипДанных;
	
	Если СвойстваИдентификатора.ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
		КвалификаторыЧисла = БазовыйТип.КвалификаторыЧисла;
		ТипЗначения = Новый ОписаниеТипов(БазовыйТип,,,Новый КвалификаторыЧисла(КвалификаторыЧисла.Разрядность, ДополнительныйПараметрЗначение, КвалификаторыЧисла.ДопустимыйЗнак));
	Иначе
		ТипЗначения = Новый ОписаниеТипов(БазовыйТип);
	КонецЕсли;
	
	Возврат ТипЗначения;
	
КонецФункции

// Возвращает значение спецсимвола окончания параметра переменной длины.
// Например, идентификатор СерийныйНомер может иметь переменную длину до 20 символов в штрихкоде.
// Если ключи идентификаторов не ограничиваются скобками, тогда в конце полей
// переменной длины должен стоять спецсимвол. Не сериализуется.
//
// Возвращаемое значение:
// 	Строка - значение не сериализуемого спецсимвола
//
Функция СимволОкончанияСтрокиПеременнойДлины() Экспорт
	Возврат Символ(29);
КонецФункции

// Возвращает массив возможных значений спецсимволов окончания строки переменной длины
//
// Возвращаемое значение:
// 	Массив - Массив строк - спецсимволов
//
Функция СимволыОкончанияСтрокиПеременнойДлины()
	Массив = Новый Массив;
	Массив.Добавить(Символ(29));
	Возврат Массив;
КонецФункции

// Возвращает массив нечитаемых символов, которые могут встретиться в штрихкоде в зависимости от оборудования
//
// Возвращаемое значение:
// 	Массив - Массив строк - спецсимволов
//
Функция НечитаемыеСимволыШтрихкодов()
	Массив = Новый Массив;
	Массив.Добавить(Символ(65533));
	Возврат Массив;
КонецФункции

#Область ГенерацияШтрихкодов

// Возвращает сгенерированный штрихкод SSCC по переданным параметрам
//
// Параметры:
// 	ПараметрыШтрихкода  - Структура - Структура входящих параметров штрихкода
// 	 * ЦифраРасширения    - Число - Цифра расширения SSCC
// 	 * ПрефиксКомпанииGS1 - Число - префикс компании GS1
// 	 * СерийныйНомерSSCC  - Число - серийный номер SSCC
// 	УстанавливатьСкобки - Булево    - Если истина, то идентификатор SSCC 00 будет помещен в скобки.
//
// Возвращаемое значение:
// 	Строка - Сгенерированный штрихкод
//
Функция ШтрихкодSSCC(ПараметрыШтрихкода, УстанавливатьСкобки = Истина) Экспорт
	
	ЦифраРасширения    = ПараметрыШтрихкода.ЦифраРасширения;
	ПрефиксКомпанииGS1 = ПараметрыШтрихкода.ПрефиксКомпанииGS1;
	СерийныйНомерSSCC  = ПараметрыШтрихкода.СерийныйНомерSSCC;
	
	Если ЗначениеЗаполнено(ПрефиксКомпанииGS1)
	   И ЗначениеЗаполнено(СерийныйНомерSSCC) Тогда
		
		Штрихкод = Формат(ЦифраРасширения, "ЧН=0; ЧГ=0")
			+ ПриведенноеКДлинеЗначение(ПрефиксКомпанииGS1, 9)
			+ ПриведенноеКДлинеЗначение(СерийныйНомерSSCC, 7);
		
		КонтрольноеЧисло = КонтрольноеЧислоSSCC(Штрихкод);
		
		Если УстанавливатьСкобки Тогда
			Штрихкод = "(00)" + Штрихкод + КонтрольноеЧисло;
		Иначе
			Штрихкод = "00" + Штрихкод + КонтрольноеЧисло;
		КонецЕсли;
	Иначе
		
		Штрихкод = "";
		
	КонецЕсли;
	
	Возврат Штрихкод;
КонецФункции

// Возвращает сгенерированный штрихкод Code128 по переданным параметрам
//
// Параметры:
// 	ПараметрыШтрихкода  - Структура - Структура входящих параметров штрихкода
// 	 * ИдентификаторОрганизации - Строка - Идентификатор организации, например ИНН или код ФСРАР
// 	 * ДатаМаркировки - Дата    - Дата маркировки упаковки
// 	 * НомерПоПорядку - Число - Порядковый номер в течении дня
//
// Возвращаемое значение:
// 	Строка - Сгенерированный штрихкод
//
Функция ШтрихкодCode128(ПараметрыШтрихкода) Экспорт
	
	ИдентификаторОрганизации = ПараметрыШтрихкода.ИдентификаторОрганизации;
	ДатаМаркировки           = ПараметрыШтрихкода.ДатаМаркировки;
	НомерПоПорядку           = ПараметрыШтрихкода.НомерПоПорядку;
	
	
	Если ЗначениеЗаполнено(ИдентификаторОрганизации)
	   И ЗначениеЗаполнено(ДатаМаркировки)
	   И ЗначениеЗаполнено(НомерПоПорядку) Тогда
		
		Штрихкод = ПриведенноеКДлинеЗначение(ИдентификаторОрганизации, 12)
			+ Формат(ДатаМаркировки, "ДФ=ddMMyy") // Установленный формат даты для штрихкодов.
			+ ПриведенноеКДлинеЗначение(НомерПоПорядку, 4);
		
	Иначе
		
		Штрихкод = "";
		
	КонецЕсли;
	
	Возврат Штрихкод;
	
КонецФункции

// Возвращает сгенерированный штрихкод в формате GS1
//
// Параметры:
// 	ИспользуемыеИдентификаторы - Массив структур используемых идентификаторов применения GS1. Свойства структур:
// 	   *ИмяИдентификатора          - Строка, имя идентификатора в верхнем регистре, например, "МАССАНЕТТОВКГ"
// 	   *КлючИдентификатора         - Строка, ключ идентификатора без значения дополнительного параметра.
// 	                                  Например, для МассаНеттоВКг указывается 310 вместо 3102.
// 	   *Значение                   - Значение идентификатора. Строка, дата, число.
// 	   *ДополнительныйПараметр     - Число. Например, для МассаНеттоВКг последняя цифра 2 в идентификаторе (3102) - количество
// 	                                      знаков после запятой.
// 	УстанавливатьСкобки - Булево    - Если истина, то коды идентификаторов (вместе с дополнительными параметрами идентификаторов,
// 	                                  при их наличии) будут помещены внутрь скобок ().
// 	СимволNFC1          - Строка    - Символ завершения параметра переменной длины.
// 	                                  Может принимать значения: "", Символ(29), [NFC1].
// 	                                  Штрихкод с символом Символ(29) не может передаваться с клиента на сервер.
//
// Возвращаемое значение:
// 	Строка - сгенерированный штрихкод. При не заполненных параметрах штрихкод сгенерирован не будет.
//
Функция ШтрихкодGS1(ИспользуемыеИдентификаторы, УстанавливатьСкобки = Истина, СимволNFC1 = "") Экспорт
	
	ВсеЗначенияЗаполнены = Истина;
	
	Для каждого СтрокаИдентификатора Из ИспользуемыеИдентификаторы Цикл
		Если Не ЗначениеЗаполнено(СтрокаИдентификатора.Значение) Тогда
			ВсеЗначенияЗаполнены = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ВсеЗначенияЗаполнены Тогда
		
		Штрихкод = "";
		
	Иначе
		
		СвойстваИдентификаторов = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
		СимволОкончания = СимволNFC1;
		
		Штрихкод = "";
		ОшибкаФормирования = Ложь;
		ПредыдущееПеременнойДлины = Ложь;
		
		Для каждого СтрокаИдентификатора Из ИспользуемыеИдентификаторы Цикл
			
			ИмяИдентификатора  = СтрокаИдентификатора.ИмяИдентификатора;
			КлючИдентификатора = СтрокаИдентификатора.КлючИдентификатора;
			
			СвойстваИдентификатора = СвойстваИдентификаторов.Получить(КлючИдентификатора);
			Если СвойстваИдентификатора = Неопределено Тогда
				ОшибкаФормирования = Истина;
				Прервать;
			КонецЕсли;
			
			Если ПредыдущееПеременнойДлины Тогда
				Штрихкод = Штрихкод + СимволОкончания;
			КонецЕсли;
			
			ПредставлениеИдентификатора = КлючИдентификатора;
			
			ДопПараметр = СтрокаИдентификатора.ДополнительныйПараметр;
			
			Если ЗначениеЗаполнено(СвойстваИдентификатора.ДополнительныйПараметрИмя) Тогда
				ПредставлениеИдентификатора = ПредставлениеИдентификатора 
					+ ПриведенноеКДлинеЗначение(ДопПараметр, СвойстваИдентификатора.ДлинаДопПараметра);
			КонецЕсли;
			Если УстанавливатьСкобки Тогда
				ПредставлениеИдентификатора = "(" + ПредставлениеИдентификатора + ")";
			КонецЕсли;
			
			Штрихкод = Штрихкод + ПредставлениеИдентификатора;
			
			Значение = СтрокаИдентификатора.Значение;
			
			Если ТипЗнч(Значение) = Тип("Дата") Тогда
				ЗначениеСтрокой = Формат(Значение, "ДФ=yyMMdd"); // Установленный формат даты для штрихкодов.
			ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
				
				ФорматнаяСтрокаЧисла = "";
				Если ЗначениеЗаполнено(СвойстваИдентификатора.ДополнительныйПараметрИмя)
				   И СвойстваИдентификатора.ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
					ФорматнаяСтрокаЧисла = "ЧДЦ=%1;";
					ФорматнаяСтрокаЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ФорматнаяСтрокаЧисла, ДопПараметр);
				КонецЕсли;
				ФорматнаяСтрокаЧисла = ФорматнаяСтрокаЧисла + "ЧРД=.;ЧН=0;ЧГ=0";
				ЗначениеСтрокой = СтрЗаменить(Формат(Значение, ФорматнаяСтрокаЧисла), ".", "");
				
			Иначе
				ЗначениеСтрокой = СокрЛП(Значение);
			КонецЕсли;
			Если Не СвойстваИдентификатора.ЗначениеПеременнойДлины Тогда
				ЗначениеСтрокой = ПриведенноеКДлинеЗначение(ЗначениеСтрокой, СвойстваИдентификатора.ДлинаКода);
			КонецЕсли;
			
			Штрихкод = Штрихкод + ЗначениеСтрокой;
			
			Если СвойстваИдентификатора.ЗначениеПеременнойДлины Тогда
				ПредыдущееПеременнойДлины = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОшибкаФормирования Тогда
			Штрихкод = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Штрихкод;
	
КонецФункции

#КонецОбласти


#Область ЧтениеШтрихкодов

// Читает штрихкод формата SSCC и возвращает параметры штрихкода
//
// Параметры:
// 	Штрихкод - Строка - Штрихкод в формате SSCC
//
// Возвращаемое значение:
// 	Структура - структура параметров
// 	 * Результат - Неопределено - Чтение штрикода завершилось неудачей
// 	             - Структура - Параметры штрихкода, если штрихкод прочитан успешно
// 	                ** ЦифраРасширения - Число - цифра расширения SSCC
// 	                ** ПрефиксКомпанииGS1 - Число - префикс компании GS1
// 	                ** СерийныйНомерSSCC  - Число - серийный номер SSCC
// 	                ** КонтрольноеЧисло   - Число - контрольная цифра штрихкода
// 	 * ТекстОшибки - Строка - Текст ошибки при чтении, если ошибки не было - то пустая строка.
//
Функция ПараметрыШтрихкодаSSCC(Штрихкод) Экспорт
	
	НечитаемыеСимволы = НечитаемыеСимволыШтрихкодов();
	Для каждого Символ Из НечитаемыеСимволы Цикл
		Штрихкод = СтрЗаменить(Штрихкод, Символ, "");
	КонецЦикла; 
	
	ПараметрыШтрихкода = Новый Структура;
	
	ТекстОшибки = "";
	
	КлючИдентификатораSSCC = "00";
	КлючИдентификатораSSCCПолный = "(00)";
	
	НомерПозицииСоСкобками = СтрНайти(Штрихкод, КлючИдентификатораSSCCПолный);
	НомерПозиции = СтрНайти(Штрихкод, КлючИдентификатораSSCC);
	ОшибкаЧтения = Ложь;
	
	Если НомерПозицииСоСкобками = 1 Тогда
		НепрочитаннаяЧастьШК = Сред(Штрихкод, СтрДлина(КлючИдентификатораSSCCПолный) + 1);
	ИначеЕсли НомерПозиции = 1 Тогда
		НепрочитаннаяЧастьШК = Сред(Штрихкод, СтрДлина(КлючИдентификатораSSCC) + 1);
	Иначе
		НепрочитаннаяЧастьШК = Штрихкод;
		
		ОшибкаЧтения = Истина;
		ТекстОшибки = НСтр("ru = 'Идентификатор SSCC ""00"" не найден в начале штрихкода'");
		
		ПараметрыШтрихкода.Вставить("Результат", Неопределено);
		ПараметрыШтрихкода.Вставить("ТекстОшибки", ТекстОшибки);
		
	КонецЕсли;
	
	Если Не ОшибкаЧтения Тогда
		ДлинаСтроки = СтрДлина(НепрочитаннаяЧастьШК);
		Если ДлинаСтроки <> 18 Тогда
			ТекстОшибки = НСтр("ru = 'Неверный формат штрихкода SSCC: общая длина штрихкода равна %1 символам, вместо %2'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДлинаСтроки, 18);
			
			ПараметрыШтрихкода.Вставить("Результат", Неопределено);
			ПараметрыШтрихкода.Вставить("ТекстОшибки", ТекстОшибки);
		Иначе
			
			Результат = Новый Структура;
			Результат.Вставить("ЦифраРасширения",    СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
				Сред(НепрочитаннаяЧастьШК, 1, 1)));
			Результат.Вставить("ПрефиксКомпанииGS1", СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
				Сред(НепрочитаннаяЧастьШК, 2, 9)));
			Результат.Вставить("СерийныйНомерSSCC",  СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
				Сред(НепрочитаннаяЧастьШК, 11, 7)));
			Результат.Вставить("КонтрольноеЧисло",   СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
				Сред(НепрочитаннаяЧастьШК, 18, 1)));
			
			ТекстОшибки = "";
			
			Если НЕ ЗначениеЗаполнено(Результат.ПрефиксКомпанииGS1) Тогда
				ТекстОшибки = НСтр("ru = 'Неверный формат штрихкода SSCC: не заполнено значение ""Префикс компании GS1""'");
				Результат   = Неопределено;
			ИначеЕсли НЕ ЗначениеЗаполнено(Результат.СерийныйНомерSSCC) Тогда
				ТекстОшибки = НСтр("ru = 'Неверный формат штрихкода SSCC: не заполнено значение ""Серийный номер SSCC""'");
				Результат   = Неопределено;
			КонецЕсли;
			
			ПараметрыШтрихкода.Вставить("Результат", Результат);
			ПараметрыШтрихкода.Вставить("ТекстОшибки", ТекстОшибки);
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Читает штрихкод формата Code128 и возвращает параметры штрихкода
//
// Параметры:
// 	Штрихкод - Строка - Штрихкод в формате Code128
//
// Возвращаемое значение:
// 	Структура - структура параметров
// 	 * Результат - Неопределено - Чтение штрикода завершилось неудачей
// 	             - Структура - Параметры штрихкода, если штрихкод прочитан успешно
// 	                ** ИдентификаторОрганизации - Строка - Идентификатор организации
// 	                ** ДатаМаркировкиСтрока - Строка - дата маркировки в формате строки
// 	                ** ДатаМаркировки       - Дата - дата маркировки упаковки
// 	                ** НомерПоПорядку - Число - порядковый номер в течении дня
// 	 * ТекстОшибки - Строка - Текст ошибки при чтении, если ошибки не было - то пустая строка.
//
Функция ПараметрыШтрихкодаCode128(Штрихкод) Экспорт
	
	НечитаемыеСимволы = НечитаемыеСимволыШтрихкодов();
	Для каждого Символ Из НечитаемыеСимволы Цикл
		Штрихкод = СтрЗаменить(Штрихкод, Символ, "");
	КонецЦикла;
	
	ПараметрыШтрихкода = Новый Структура;
	
	ПараметрыШтрихкода.Вставить("ТекстОшибки",  "");
	
	ДлинаСтроки = СтрДлина(Штрихкод);
	Если ДлинаСтроки <> 22 Тогда
		ТекстОшибки  = НСтр("ru = 'Неверный формат штрихкода Code-128: общая длина штрихкода равна %1 символам, вместо %2'");
		ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДлинаСтроки, 22);
		
		ПараметрыШтрихкода.Вставить("Результат", Неопределено);
		ПараметрыШтрихкода.Вставить("ТекстОшибки", ТекстОшибки);
	Иначе
		Результат = Новый Структура;
		Результат.Вставить("ИдентификаторОрганизации",   Сред(Штрихкод, 1, 12));
		Результат.Вставить("ДатаМаркировкиСтрока",       Сред(Штрихкод, 12, 6));
		Результат.Вставить("ДатаМаркировки", СтроковыеФункцииКлиентСервер.СтрокаВДату(Сред(Штрихкод, 13, 6)));
		Результат.Вставить("НомерПоПорядку", СтроковыеФункцииКлиентСервер.СтрокаВЧисло(
			Сред(Штрихкод, 19, 4)));
		
		ТекстОшибки = "";
		
		Если НЕ ЗначениеЗаполнено(Результат.ИдентификаторОрганизации) Тогда
			ТекстОшибки  = НСтр("ru = 'Неверный формат штрихкода Code-128: не заполнено значение ""Идентификатор организации""'");
			Результат    = Неопределено;
		ИначеЕсли НЕ ЗначениеЗаполнено(Результат.ДатаМаркировки) Тогда
			ТекстОшибки  = НСтр("ru = 'Неверный формат штрихкода Code-128: не заполнено значение ""Дата маркировки""'");
			Результат    = Неопределено;
		ИначеЕсли НЕ ЗначениеЗаполнено(Результат.НомерПоПорядку) Тогда
			ТекстОшибки  = НСтр("ru = 'Неверный формат штрихкода Code-128: не заполнено значение ""Номер по порядку""'");
			Результат    = Неопределено;
		КонецЕсли;
		
		ПараметрыШтрихкода.Вставить("Результат", Результат);
		ПараметрыШтрихкода.Вставить("ТекстОшибки", "");
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Читает штрихкод и возвращает параметры. Ключи идентификаторов применения не заключены в скобки,
// но после параметров переменной длины следует символ окончания параметра переменной длины.
//
// Параметры:
// 	Штрихкод     - Строка - Штрихкод, считанный со сканера.
// 	ПараметрыШтрихкода - Неопределено
// 	                   - Структура    - накопленные считанные параметры штрихкода.
//
// Возвращаемое значение:
// 	Структура
// 	 * Результат - Неопределено - Если в процессе чтения возникла ошибка.
// 	             - Массив - Массив структур считанных параметров. Свойства структур:
// 	               ** КлючИдентификатора - Строка, ключ идентификатора, заданный без дополнительного параметра.
// 	                                       Например, для МассаНеттоВКг будет 310 вместо 3100, 3101, 3102, 3103 и т.д.
// 	               ** ИмяИдентификатора      - Строка - Имя идентификатора применения в верхнем регистре, например "МАССАНЕТТОВКГ".
// 	               ** ДополнительныйПараметр - Число - По умолчанию 0.
// 	               ** ЗначениеСтрокой    - Строка - Считанное значение строкой.
// 	               ** Значение           - Строка, Число, Дата - Считанное и преобразованное по правилам значение.
// 	 * ТекстОшибки - Строка     - Содержит текст ошибки считывания, при ее наличии.
//
Функция ПараметрыШтрихкодаGS1(Знач Штрихкод, ПараметрыШтрихкода = Неопределено) Экспорт
	
	Если ПараметрыШтрихкода = Неопределено Тогда
		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Результат", Новый Массив);
		ПараметрыШтрихкода.Вставить("ТекстОшибки",  "");
		
		НечитаемыеСимволы = НечитаемыеСимволыШтрихкодов();
		Для каждого Символ Из НечитаемыеСимволы Цикл
			Штрихкод = СтрЗаменить(Штрихкод, Символ, "");
		КонецЦикла;
	КонецЕсли;
	
	КлючИдентификатораSSCC = "00";
	
	НомерПозиции = СтрНайти(Штрихкод, КлючИдентификатораSSCC);
	Если НомерПозиции = 1 Тогда
		
		ПараметрыШтрихкода.Результат = Неопределено;
		ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'Это тип штрихкода SSCC. Идентификатор применения равен %1'");
		ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПараметрыШтрихкода.ТекстОшибки, КлючИдентификатораSSCC);
		
	Иначе
		
		СимволыОкончанияСтрокиПеременнойДлины = СимволыОкончанияСтрокиПеременнойДлины();
		СвойстваИдентификаторов = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
		
		ТекущийИдентификаторПримененияНайден = Ложь;
		Для каждого КлючИЗначение Из СвойстваИдентификаторов Цикл
			
			КлючИдентификатора = КлючИЗначение.Ключ;
			СвойстваИдентификатораПрименения = КлючИЗначение.Значение;
			
			НомерПозиции = СтрНайти(Штрихкод, КлючИдентификатора);
			Если НомерПозиции = 1 Тогда
				ТекущийИдентификаторПримененияНайден = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекущийИдентификаторПримененияНайден Тогда
			
			Штрихкод = Сред(Штрихкод, СтрДлина(КлючИдентификатора)+1);
			
			// Вычисляем длину значения параметра.
			// Если параметр переменной длины, то последим символом будет либо последний символ определенной длины (если ДлинаЗначения <> 0),
			// либо символ окончания параметра переменной длины (один из заданных в массиве СимволыОкончанияСтрокиПеременнойДлины).
			
			ДлинаЗначенияПараметра = СвойстваИдентификатораПрименения.ДлинаКода;
			ДлинаДопПараметра = СвойстваИдентификатораПрименения.ДлинаДопПараметра;
			
			ЗначениеДопПараметраСтрока = "";
			Если ДлинаДопПараметра > 0 Тогда
				ЗначениеДопПараметраСтрока = Сред(Штрихкод, 1, 1);
				Штрихкод = Сред(Штрихкод, 2);
			КонецЕсли;
			
			Если СвойстваИдентификатораПрименения.ЗначениеПеременнойДлины Тогда
				НомерПозиции = 0;
				СимволОкончания = "";
				
				Для каждого СимволОкончания Из СимволыОкончанияСтрокиПеременнойДлины Цикл
					НомерПозиции = СтрНайти(Штрихкод, СимволОкончания);
					Если Не НомерПозиции = 0 Тогда
						Прервать; // Используется только один символ окончания.
					КонецЕсли;
				КонецЦикла;
				Если НомерПозиции <> 0 И ДлинаЗначенияПараметра <> 0 Тогда
					ДлинаЗначенияПараметра = Мин(НомерПозиции, ДлинаЗначенияПараметра);
				ИначеЕсли НомерПозиции <> 0 И ДлинаЗначенияПараметра = 0 Тогда
					ДлинаЗначенияПараметра = НомерПозиции;
				КонецЕсли;
			КонецЕсли;
			
			Если ДлинаЗначенияПараметра = 0 Тогда
				СтроковоеЗначениеПараметра = Сред(Штрихкод, 1); // По конец строки.
				Штрихкод = "";
			Иначе
				СтроковоеЗначениеПараметра = Сред(Штрихкод, 1, ДлинаЗначенияПараметра);
				СтроковоеЗначениеПараметра = СтрЗаменить(СтроковоеЗначениеПараметра, СимволОкончания, "");
				Штрихкод = Сред(Штрихкод, ДлинаЗначенияПараметра + 1);
			КонецЕсли;
			
			ТекстОшибки = "";
			Результат = ПараметрЗначенияИдентификатораПрименения(СвойстваИдентификатораПрименения,
				                                                 КлючИдентификатора,
				                                                 ЗначениеДопПараметраСтрока,
				                                                 СтроковоеЗначениеПараметра,
				                                                 ТекстОшибки);
			
			Если Результат = Неопределено Тогда
				ПараметрыШтрихкода.Вставить("Результат",   Неопределено);
				ПараметрыШтрихкода.Вставить("ТекстОшибки", ТекстОшибки);
				Возврат ПараметрыШтрихкода;
			КонецЕсли;
			
			ПараметрыШтрихкода.Результат.Добавить(Результат);
			
			Если Не ПустаяСтрока(Штрихкод) Тогда
				Если Сред(Штрихкод, 1, 1) = СимволОкончания Тогда
					Штрихкод = Сред(Штрихкод, 2);
				КонецЕсли;
			КонецЕсли;
			Если Не ПустаяСтрока(Штрихкод) Тогда
				ПараметрыШтрихкодаGS1(Штрихкод, ПараметрыШтрихкода);
			КонецЕсли;
			
		Иначе
			
			ПараметрыШтрихкода.Результат   = Неопределено;
			ПараметрыШтрихкода.ТекстОшибки =
				НСтр("ru = 'Неизвестный идентификатор применения GS1-128 в части штрихкода ""%1""'");
			ПараметрыШтрихкода.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПараметрыШтрихкода.ТекстОшибки, Штрихкод);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Читает штрихкод и возвращает параметры. Ключи идентификаторов применения заключены в скобки,
// но после параметров переменной длины1 не следует символ окончания параметра переменной длины.
// В данном формате штрихкод храниться в поле ИБ.
// См. описание функции ПараметрыШтрихкодаGS1.
//
Функция ПараметрыШтрихкодаGS1СоСкобками(Знач Штрихкод, ПараметрыШтрихкода = Неопределено) Экспорт
	
	Если ПараметрыШтрихкода = Неопределено Тогда
		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Результат", Новый Массив);
		ПараметрыШтрихкода.Вставить("ТекстОшибки",  "");
		
		НечитаемыеСимволы = НечитаемыеСимволыШтрихкодов();
		Для каждого Символ Из НечитаемыеСимволы Цикл
			Штрихкод = СтрЗаменить(Штрихкод, Символ, "");
		КонецЦикла;
		
		// Если есть символы окончания строк переменной длины, то удаляем ,т.к. есть скобки
		// явно указывающие начало следующего идентификатора применения.
		СимволыОкончанияСтрокиПеременнойДлины = СимволыОкончанияСтрокиПеременнойДлины();
		Для каждого СимволОкончания Из СимволыОкончанияСтрокиПеременнойДлины Цикл
			Штрихкод = СтрЗаменить(Штрихкод, СимволОкончания, "");
		КонецЦикла;
		
		КлючИдентификатораSSCC = "(00)";
		НомерПозиции = СтрНайти(Штрихкод, КлючИдентификатораSSCC);
		Если НомерПозиции <> 0 Тогда
			ПараметрыШтрихкода.Результат = Неопределено;
			ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'Это тип штрихкода SSCC. Штрихкод содержит идентификатор применения %1'");
			ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПараметрыШтрихкода.ТекстОшибки, КлючИдентификатораSSCC);
				
			Возврат ПараметрыШтрихкода;
		КонецЕсли;
		
	КонецЕсли;
	
	СвойстваИдентификаторов = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
	
	// Читаем текущий идентификатор применения.
	ПозицияНачало = СтрНайти(Штрихкод, "(");
	ПозицияКонец  = СтрНайти(Штрихкод, ")");
	
	Если ПозицияНачало <> 1
	 ИЛИ ПозицияКонец = 0 Тогда
		ПараметрыШтрихкода.Результат = Неопределено;
		ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'В части штрихкода ""%1"" не найдено скобок, ограничивающих идентификатор применения'");
		ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПараметрыШтрихкода.ТекстОшибки, Штрихкод);
		
		Возврат ПараметрыШтрихкода;
	КонецЕсли;
	
	КлючИдентификатора = Сред(Штрихкод, ПозицияНачало + 1, ПозицияКонец - ПозицияНачало - 1);
	
	Штрихкод = Сред(Штрихкод, ПозицияКонец + 1);
	
	// Читаем значение текущего идентификатора применения.
	ПозицияНачалоСледующего = СтрНайти(Штрихкод, "(");
	
	Если ПозицияНачалоСледующего <> 0 Тогда
		СтроковоеЗначениеПараметра = Сред(Штрихкод, 1, ПозицияНачалоСледующего - 1);
		Штрихкод = Сред(Штрихкод, ПозицияНачалоСледующего);
	Иначе
		СтроковоеЗначениеПараметра = Штрихкод;
		Штрихкод = "";
	КонецЕсли;
	
	// Находим текущий идентификатор применения. Сначала ищем по полному ключу.
	// Если не найден по полному ключу, то предполагаем, что последний символ - доп.параметр.
	ЗначениеДопПараметраСтрока = "";
	СвойстваИдентификатора = СвойстваИдентификаторов.Получить(КлючИдентификатора);
	Если СвойстваИдентификатора = Неопределено Тогда
		ЗначениеДопПараметраСтрока = Прав(КлючИдентификатора, 1);
		КлючИдентификатора = Сред(КлючИдентификатора, 1, СтрДлина(КлючИдентификатора) - 1);
		
		СвойстваИдентификатора = СвойстваИдентификаторов.Получить(КлючИдентификатора);
	КонецЕсли;
	
	// Проверки
	Если СвойстваИдентификатора = Неопределено Тогда
		ПараметрыШтрихкода.Результат = Неопределено;
		ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'Не найден идентификатор применения GS1 по ключу ""%1""'");
		ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПараметрыШтрихкода.ТекстОшибки, КлючИдентификатора + ЗначениеДопПараметраСтрока);
		
		Возврат ПараметрыШтрихкода;
	КонецЕсли;
	
	Если ЗначениеДопПараметраСтрока <> ""
		И Не ЗначениеЗаполнено(СвойстваИдентификатора.ДополнительныйПараметрИмя) Тогда
		ПараметрыШтрихкода.Результат = Неопределено;
		ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'Найден дополнительный параметр ""%1"" для идентификатора ""%2""'");
		ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПараметрыШтрихкода.ТекстОшибки, ЗначениеДопПараметраСтрока, КлючИдентификатора);
		
		Возврат ПараметрыШтрихкода;
	КонецЕсли;
	
	Если СвойстваИдентификатора.ДлинаКода <> 0
		И СтрДлина(СтроковоеЗначениеПараметра) > СвойстваИдентификатора.ДлинаКода Тогда
		ПараметрыШтрихкода.Результат = Неопределено;
		ПараметрыШтрихкода.ТекстОшибки = НСтр("ru = 'Значение параметра ""%1"" для идентификатора ""%2"" больше установленной максимальной длины %3 символов'");
		ПараметрыШтрихкода.ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПараметрыШтрихкода.ТекстОшибки, СтроковоеЗначениеПараметра,
			КлючИдентификатора + ЗначениеДопПараметраСтрока, СвойстваИдентификатора.ДлинаКода);
		
		Возврат ПараметрыШтрихкода;
	КонецЕсли;
	
	ТекстОшибки = "";
	Результат = ПараметрЗначенияИдентификатораПрименения(СвойстваИдентификатора,
		                                                 КлючИдентификатора,
		                                                 ЗначениеДопПараметраСтрока,
		                                                 СтроковоеЗначениеПараметра,
		                                                 ТекстОшибки);
	
	Если Результат = Неопределено Тогда
		ПараметрыШтрихкода.Вставить("Результат",    Неопределено);
		ПараметрыШтрихкода.Вставить("ТекстОшибки",  ТекстОшибки);
		Возврат ПараметрыШтрихкода;
	КонецЕсли;
	
	ПараметрыШтрихкода.Результат.Добавить(Результат);
	
	Если Не ПустаяСтрока(Штрихкод) Тогда
		ПараметрыШтрихкодаGS1СоСкобками(Штрихкод, ПараметрыШтрихкода);
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Читает штрихкод неизвестного типа штрихкода и возвращает параметры.
// Для каждого типа штрихкода возвращаются соответствующие параметры. 
// См. описание функций ПараметрыШтрихкодаSSCC, ПараметрыШтрихкодаCode128, ПараметрыШтрихкодаGS1
Функция ПараметрыШтрихкода(Штрихкод) Экспорт
	ИдентификаторSSCC = "00";
	ИдентификаторSSCCПолный = "(00)";
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Результат", Неопределено);
	ПараметрыШтрихкода.Вставить("ТекстОшибки",  "");
	ПараметрыШтрихкода.Вставить("ТипШтрихкода", Неопределено);
	
	Если СтрНайти(Штрихкод, ИдентификаторSSCCПолный) = 1 Тогда
		ПараметрыШтрихкода = ПараметрыШтрихкодаSSCC(Штрихкод);
		ПараметрыШтрихкода.Вставить("ТипШтрихкода", ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC"));
	ИначеЕсли СтрНайти(Штрихкод, ИдентификаторSSCC) = 1
	        И СтрДлина(Штрихкод) = 20
	        И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод)
	        И КонтрольноеЧислоSSCC(Сред(Штрихкод, 3, СтрДлина(Штрихкод) - 3)) = Число(Прав(Штрихкод, 1)) Тогда
		ПараметрыШтрихкода = ПараметрыШтрихкодаSSCC(Штрихкод);
		ПараметрыШтрихкода.Вставить("ТипШтрихкода", ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC"));
	Иначе
		
		Если СтрНайти(Штрихкод, "(") > 0 Тогда
			ПараметрыШтрихкода = ПараметрыШтрихкодаGS1СоСкобками(Штрихкод);
			Если НЕ ПараметрыШтрихкода.Результат = Неопределено Тогда
				ПараметрыШтрихкода.Вставить("ТипШтрихкода", ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128"));
			КонецЕсли;
		Иначе
			ПараметрыШтрихкода = ПараметрыШтрихкодаGS1(Штрихкод);
			Если НЕ ПараметрыШтрихкода.Результат = Неопределено Тогда
				ПараметрыШтрихкода.Вставить("ТипШтрихкода", ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128"));
			КонецЕсли;
		КонецЕсли;
		
		ШтрикодСодержитСимволыGS1 = Ложь;
		СимволыGS1 = СимволыОкончанияСтрокиПеременнойДлины();
		СимволыGS1.Добавить("(");
		Для каждого Символ Из СимволыGS1 Цикл
			Если Найти(Штрихкод, Символ) > 0 Тогда
				ШтрикодСодержитСимволыGS1 = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ШтрикодСодержитСимволыGS1 Тогда
			Если ПараметрыШтрихкода.Результат = Неопределено Тогда
				ПараметрыШтрихкода = ПараметрыШтрихкодаCode128(Штрихкод);
				Если НЕ ПараметрыШтрихкода.Результат = Неопределено Тогда
					ПараметрыШтрихкода.Вставить("ТипШтрихкода", ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.Code128"));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
КонецФункции

#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает рассчитанное контрольное число.
//
// Параметры:
// 	Штрихкод - Строка - часть штрихкода SSCC, состоящая из цифр, без идентификатора применения SSCC
// 	                    (00 или (00)) и без контролькой цифры
//
// Возвращаемое значение:
// 	Число - Цифра контрольного числа SSCC
//
Функция КонтрольноеЧислоSSCC(Штрихкод)
	КонтрольноеЧисло = 0;
	
	Цифры = Новый Массив;
	Позиций  = СтрДлина(Штрихкод);
	Для НомерПозиции = 1 По Позиций Цикл
		Цифры.Добавить(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Сред(Штрихкод, НомерПозиции, 1)));
	КонецЦикла;
	
	СуммаЧетных = 0;
	СуммаНечетных = 0;
	Для НомерПозиции = 0 По Позиций-1 Цикл
		Если НомерПозиции%2=0 Тогда
			СуммаЧетных=СуммаЧетных+Цифры[НомерПозиции];
		Иначе
			СуммаНечетных=СуммаНечетных+Цифры[НомерПозиции];
		КонецЕсли;
	КонецЦикла;
	
	СверяемоеЧисло = СуммаЧетных * 3 + СуммаНечетных;
	КонтрольноеЧисло = 10 - СверяемоеЧисло%10;
	Если КонтрольноеЧисло = 10 Тогда
		КонтрольноеЧисло = 0;
	КонецЕсли;
	
	Возврат КонтрольноеЧисло;
КонецФункции

Функция ПриведенноеКДлинеЗначение(Знач ИсходнаяСтрока, Длина)
	Если ТипЗнч(ИсходнаяСтрока) = Тип("Число") Тогда
		Строка = Формат(ИсходнаяСтрока, "ЧН=0; ЧГ=0");
	Иначе
		Строка = СокрЛП(ИсходнаяСтрока);
	КонецЕсли;
	ТекущаяДлина = СтрДлина(Строка);
	Пока ТекущаяДлина < Длина Цикл
		Строка = "0" + Строка;
		ТекущаяДлина = ТекущаяДлина + 1;
	КонецЦикла;
	
	Возврат Строка;
КонецФункции

Функция ПараметрЗначенияИдентификатораПрименения(СвойстваИдентификатораПрименения, КлючИдентификатора, ДополнительныйПараметр, ЗначениеСтрокой, ТекстОшибки = "")
	
	ПараметрЗначенияИдентификатора = Новый Структура;
	ПараметрЗначенияИдентификатора.Вставить("КлючИдентификатора",     КлючИдентификатора);
	ПараметрЗначенияИдентификатора.Вставить("ИмяИдентификатора",      СвойстваИдентификатораПрименения.ИмяИдентификатора);
	ПараметрЗначенияИдентификатора.Вставить("ДополнительныйПараметрСтрокой", ДополнительныйПараметр);
	ПараметрЗначенияИдентификатора.Вставить("ДополнительныйПараметр", 
		СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметр));
	ПараметрЗначенияИдентификатора.Вставить("ЗначениеСтрокой",        ЗначениеСтрокой);
	
	ТипЗначенияИдентификатора = СвойстваИдентификатораПрименения.БазовыйТипДанных;
	Если СвойстваИдентификатораПрименения.ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
		ИсходныйКвалификатор = ТипЗначенияИдентификатора.КвалификаторыЧисла;
		НовыйКвалификатор = Новый КвалификаторыЧисла(ИсходныйКвалификатор.Разрядность, ДополнительныйПараметр, ИсходныйКвалификатор.ДопустимыйЗнак);
		ТипЗначенияИдентификатора = Новый ОписаниеТипов(ТипЗначенияИдентификатора,,,НовыйКвалификатор);
	КонецЕсли;
	
	Если ТипЗначенияИдентификатора.СодержитТип(Тип("Дата")) Тогда
		ЗначениеПараметра = СтрокаGS1ВДату(ЗначениеСтрокой, ТипЗначенияИдентификатора, ТекстОшибки);
		Если ЗначениеПараметра = Неопределено Тогда
			ПараметрЗначенияИдентификатора = Неопределено;
			Возврат ПараметрЗначенияИдентификатора;
		КонецЕсли;
	ИначеЕсли ТипЗначенияИдентификатора.СодержитТип(Тип("Число")) Тогда
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЗначениеСтрокой) Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка преобразования значения параметра %1 к числу'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЗначениеСтрокой);
			
			ПараметрЗначенияИдентификатора = Неопределено;
			Возврат ПараметрЗначенияИдентификатора;
		КонецЕсли;
		Если СвойстваИдентификатораПрименения.ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
			ЗначениеДопПараметра = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметр);
			СтроковоеЗначениеПараметра = ЗначениеСтрокой;
			Если ЗначениеДопПараметра > 0 Тогда
				СтроковоеЗначениеПараметра = Лев(ЗначениеСтрокой, СтрДлина(СтроковоеЗначениеПараметра) - ЗначениеДопПараметра)
				+ "." + Прав(ЗначениеСтрокой, ЗначениеДопПараметра);
			КонецЕсли;
			ЗначениеПараметра = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтроковоеЗначениеПараметра);
		Иначе
			СтроковоеЗначениеПараметра = ЗначениеСтрокой;
			ЗначениеПараметра = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтроковоеЗначениеПараметра);
		КонецЕсли;
	Иначе
		ЗначениеПараметра = ЗначениеСтрокой;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра)
		И НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		ТекстОшибки = НСтр("ru = 'Ошибка чтения параметра ""%1""'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОшибки,
			СвойстваИдентификатораПрименения.ПредставлениеИдентификатора);
		ПараметрЗначенияИдентификатора = Неопределено;
		Возврат ПараметрЗначенияИдентификатора;
		
	КонецЕсли;
	
	ПараметрЗначенияИдентификатора.Вставить("Значение", ЗначениеПараметра);
	
	Возврат ПараметрЗначенияИдентификатора;
	
КонецФункции

// См. описание СтроковыеФункцииКлиентСервер.СтрокаВДату.
// По формату GS1-128 дата имеет формат yyMMdd.
//
Функция СтрокаGS1ВДату(Знач Значение, Знач ОписаниеТиповДаты, ТекстОшибки = "")
	
	ЧастьДаты = ОписаниеТиповДаты.КвалификаторыДаты.ЧастиДаты;
	
	ПозицияПробела = СтрНайти(Значение, " ", НаправлениеПоиска.СНачала);
	Если ПозицияПробела > 0 Тогда
		Значение = Лев(Значение, ПозицияПробела - 1);
	КонецЕсли;
	Значение = СтрЗаменить(Значение, " ", "");
	Значение = СокрЛП(СтрЗаменить(Значение, ".", ""));
	Значение = СокрЛП(СтрЗаменить(Значение, "/", ""));
	Значение = СокрЛП(СтрЗаменить(Значение, "-", ""));
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Значение) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка преобразования значения параметра %1 к дате'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Значение);
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЧастьДаты = ЧастиДаты.Дата Тогда
		Если СтрДлина(Значение) = 6 Тогда
			Год = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Лев(Значение, 2));
			Значение = ?(Год > 29, "19", "20") + Значение;
		КонецЕсли;
	КонецЕсли;
	
	Результат    = ОписаниеТиповДаты.ПривестиЗначение(Значение);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти