$( document ).ready(function() {
	
	// uncheck all swifts of previously selected instrument in case user select another payment instrument
	$('#gopay-payment .instrument>label>input:radio').change(function(){
		clicked = this;
		$('#gopay-payment .instrument>label>input:radio').each(function(){
			if(this != clicked){
				$(this).parents(".instrument").find(".swifts>.swift>label>input:radio").prop("checked", false);
			}
		});
	});

	// automatically check the payment instrument in case user select particular swift and uncheck all other payment instruments
	$('#gopay-payment .swifts>.swift>label>input:radio').change(function(){
		$(this).parents("#gopay-payment .instrument>label>input:radio").prop("checked", false);
		$(this).parents(".instrument").find("label>input:radio").prop("checked", true);
		// some weird behavior in webkit, so because of it I had to add also next line:
		$(this).prop("checked", true);
	});
	
	
});