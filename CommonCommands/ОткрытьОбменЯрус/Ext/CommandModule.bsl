﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("ОбщаяФорма.", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ОткрытьФорму("ОбщаяФорма.ОбменыДанными", , 
					ПолучитьОбменЯрус());

КонецПроцедуры
&НаСервере
Функция ПолучитьОбменЯрус()
	Возврат ПланыОбмена.ОбменWMSKIS.НайтиПоНаименованию("WMS");
КонецФункции
				

