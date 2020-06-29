from __future__ import division

def lambda_handler(event, context):
   number1 = event['Number1']
   number2 = event['Number2']
   sum = number1 + number2
   product = number1 * number2
   difference = abs(number1 - number2)
   quotient = number1 / number2
   return {
       "Number1": number1,
       "Number2": number2,
       "Sum": sum,
       "Product": product,
       "Difference": difference,
       "Quotient": quotient
   }
