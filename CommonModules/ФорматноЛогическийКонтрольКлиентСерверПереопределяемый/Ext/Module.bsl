﻿
#Область ПрограммныйИнтерфейс

// Функция переопределяет типовой форматно-логический контроль чека.
// Параметры:
//   ОбщиеПараметры - Структура, полученная ранее методом МенеджерОборудованияКлиентСервер.ПараметрыОперацииФискализацииЧека,
//                    и заполненная данными чека.
//                    Содержит параметры для контроля:
//                      СпособФорматноЛогическогоКонтроля - ПеречислениеСсылка.СпособыФорматноЛогическогоКонтроля - если не заполнена,
//                                                         то контроль не выполняется,
//                      ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число - по умолчанию установленное 54-ФЗ отклонение - 0.01,
//
//   СтандартнаяОбработка - Булево - Если присваивается значение Ложь, то стандарнтый контроль выполняться не будет.
//
//   ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудования - не обязательный.
//                              Если заполнено оборудование и не заполнен способ контроля в общих параметрах,
//                              то способ контроля и допустимое расхождение можно получать из подключаемого оборудования.
Процедура ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры, СтандартнаяОбработка, ПодключаемоеОборудование = Неопределено) Экспорт
	
КонецПроцедуры

// Функция выполняет разделение фискальной строки.
//
Процедура РазделитьФискальнуюСтроку(ТекущаяПозиция, НовыеПозицииЧека, РасчетнаяЦена, РазницаСумм, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Функция выполняет проверку необходимости форматно-логическоко контроля.
//
Функция НуженФорматноЛогическийКонтроль(ОбщиеПараметры, СтандартнаяОбработка) Экспорт
	
КонецФункции

// Функция получает структуру данных форматно-логического контроля.
//
Функция ПолучитьСтруктуруДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудовани, СтруктураДанныхФорматноЛогическогоКонтроля, СтандартнаяОбработкае) Экспорт
 	
КонецФункции
 
#КонецОбласти
