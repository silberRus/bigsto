﻿#Область ПрограммныйИнтерфейс

// Предлагает пользователю создать резервную копию.
//
Процедура ПредложитьПользователюСоздатьРезервнуюКопию() Экспорт
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РезервноеКопированиеОбластейДанных Тогда
		
		ИмяФормы = "ОбщаяФорма.СозданиеРезервнойКопии";
		
	Иначе
		
		ИмяФормы = "ОбщаяФорма.ВыгрузкаДанных";
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ИнтеграцияПодсистемБСПКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме.
Процедура ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат) Экспорт
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		
		Результат = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСПКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию.
Процедура ПриПредложенииПользователюСоздатьРезервнуюКопию() Экспорт
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		
		ПредложитьПользователюСоздатьРезервнуюКопию();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти