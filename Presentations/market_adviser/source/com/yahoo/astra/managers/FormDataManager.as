/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿﻿
	import com.yahoo.astra.containers.formClasses.FormItem;
	 * Collects user input data and validate it before you submit the data to the server. 
	 * Astra does not provide a separate validation class, but there are compatible validation classes available from Adobe. 
	 * Another option for the validation is the mx.validators distributed in the Flex SDK. For convenient use of Flex validators, you can use the Astra <code>MXValidatorHelper</code> class. 
	 * Flex MXvalidator provides a variety of validation types and detailed error messages. However, the use of the MXvalidator will increase your overall file size by approximately 20K.
	 * @example The following code shows a use of <code>FormDataManager</code>:
	 * @see com.yahoo.astra.utils.ValueParser
	 * @see com.yahoo.astra.utils.MXValidationHelper
	 * @see http://code.google.com/p/flash-validators
	 * @author kayoh  
	 */
	public class FormDataManager extends EventDispatcher implements IFormDataManager {
		//--------------------------------------
		// Constructor
		//--------------------------------------
		/**
		 * Constructor.
		 */
		public function FormDataManager(customValuePaser : Class = null) {
			valueParser = (customValuePaser) ? customValuePaser : ValueParser;
			managerArray = [];
		}

		// Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var valueParser : Class = null;
		/**
		 * @private
		 */
		private var managerArray : Array = [];
		/**
		 * @private
		 */
		private var validFunction : Function = null;
		/**
		 * @private
		 */
		private var inValidFunction : Function = null;
		/**
		 */
		private var idToRemove : String ;
		/**
		 * @private

		 * Sets the method to be called as a handler function, when validation is success(FormDataManagerEvent.VALIDATION_PASSED).
		 */
		public  function get functionValidationPassed() : Function {
			return _functionValidationPassed;
		}

		 * @private
		 */
		public  function set functionValidationPassed(value : Function) : void {
			_functionValidationPassed = value;
		}

		 * @private
		 */
		private var _functionValidationFailed : Function = null;

		 * Gets and sets the method to be called as a handler function, when validation is failed(FormDataManagerEvent.VALIDATION_FAILED).
		 */
		public  function get functionValidationFailed() : Function {
			return _functionValidationFailed;
		}

		 * @private
		 */
		public  function set functionValidationFailed(value : Function) : void {
			_functionValidationFailed = value;
		}

		 * @private
		 */
		private var _errorString : String = FormLayoutStyle.DEFAULT_ERROR_STRING;

		 * Gets and sets the text representing error.
		 * 
		 * @default "Invalid input"
		 */
		public  function get errorString() : String {
			return _errorString;
		}

		 * @private
		 */
		public  function set errorString(value : String) : void {
			_errorString = value;
		}

		 * @private
		 */
		private static var _collectedData : Object;

		 * Collection of form input data variables object array. 
		 * The <code>"id"</code> will be the key and the user input from the <code>"source"</code> will be value of the array.(e.g. collectedData["zip"] = "94089")
		 * You can loop over each value within the <code>collectedData</code> object instance by using a for..in loop.
		 * 
		 * @example The following code configures shows usage of <code>collectedData</code>:
		 * <listing version="3.0">
		 *		trace( i + " : " + FormDataManager.collectedData[i] + "\n");  
		 *	}
		 *	// state : CA
		 *	// zip :  94089
		 * </listing>
		 * 
		 */
		public static function get collectedData() : Object {
			return _collectedData;
		}

		 * @private
		 */
		public static function set collectedData(value : Object) : void {
			_collectedData = value;
		}

		 * @private
		 */
		private static var _failedData : Object = null;

		 * Collection of error messages object array. 
		 * Any error string from validation or default <code>errorString</code> will be collected as a object array with <code>"id"</code> as a key and the message as value.
		 * 
		 *  * @example The following code configures shows usage of <code>failedData</code>:
		 * <listing version="3.0">
		 *		trace( i + " : " + FormDataManager.failedData[i] + "\n");  
		 *	}
		 *	// zip : Unkown Zip type.
		 *	// email : The email address contains invalid characters.
		 * </listing>
		 */
		public static function get failedData() : Object {
			return _failedData;
		}

		 * @private
		 */
		public static function set failedData(value : Object) : void {
			_failedData = value;
		}


			return this._dataSource;
		}

		 * @private
		 */
		public function set dataSource(value : Object) : void {
			this._dataSource = value;
			buildFromDataSource();
		}

		//  Public Methods
		//--------------------------------------
		
		public function addItem(id : String, source : Object, property : Object = null , required : Boolean = false , validation : Function = null, validatorExtraParam : Object = null,eventTargetObj : DisplayObject = null,functionValidationPassed : Function = null,functionValidationFailed : Function = null, errorString : String = null) : void {
			var valueParserObject : * = new valueParser();
			var valueParser : IValueParser = ( valueParserObject is IValueParser) ? valueParserObject : new ValueParser();
			if(eventTargetObj ) {
				var handlerSuccessFunction : Function = (functionValidationPassed is Function) ? functionValidationPassed : this.functionValidationPassed;
				var handlerFailFunction : Function = (functionValidationFailed is Function) ? functionValidationFailed : this.functionValidationFailed;
				if(handlerSuccessFunction is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_PASSED, handlerSuccessFunction);
				if(handlerFailFunction is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_FAILED, handlerFailFunction);
			}
		}	


		 * Starts collecting and validating data.
		 * @param e MouseEvent
		public function collectData(e : MouseEvent = null) : void {
			FormDataManager.collectedData = FormDataManager.failedData = null;
			FormDataManager.collectedData = {};	
			FormDataManager.failedData = {};	
			var passedBool : Boolean = true;
			
			for (var j : Number = 0;j < arrLeng; j++) {
				if(managerArray[j].eventTargetObj is FormItem) {
					var curFormItme : FormItem = managerArray[j].eventTargetObj as FormItem;
					curFormItme.gotResultBool = true;
				}
			}
			for (var i : Number = 0;i < arrLeng; i++) {
				passedBool &&= result;
			}	
			
			(passedBool) ? this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_SUCCESS, false, false, null, FormDataManager.collectedData)) : this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_FAIL, false, false, FormDataManager.failedData, collectedData));
		}

		 * Registers a button(DisplayObject) to trigger <code>collectData</code> by MouseEvent.CLICK event.
		 * Also sets <code>functionDataCollectionSuccess</code> and <code>functionDataCollectionFail</code> to be triggered when <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> or <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code> happens.
		 * 
		 * @param button DisplayObject button to be clicked.
		 */

			if(functionDataCollectionSuccess is Function) { 
				validFunction = functionDataCollectionSuccess;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_SUCCESS, functionDataCollectionSuccess);
			}
			if(functionDataCollectionFail is Function) { 
				inValidFunction = functionDataCollectionFail;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_FAIL, functionDataCollectionFail);
			}
			if(button is DisplayObject) {
				button.addEventListener(MouseEvent.CLICK, collectData);
			}
		}



