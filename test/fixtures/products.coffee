module.exports =
  valid: [
    products:       []
    addresses: [
      salutation: 'Herr'
      firstName:  'Stephan'
      lastName:   'Meißner'
      street1:    'Rennerstr. 11c'
      street2:    ''
      zip:        '4614'
      city:       'Machtrenk'
      email:      'meist@infoniqa.com'
      country:    'at'
    ]
    shippingCost:   5.40
    comment:        'Bitte mit Liebe verpacken *g*.'
  ]
  # -------------------------------------------------------
  invalid:
    'Kein Vorname':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  ''
        lastName:   'Meißner'
        street1:    'Rennerstr. 11c'
        street2:    ''
        zip:        '4614'
        city:       'Machtrenk'
        email:      'meist@infoniqa.com'
        country:    'at'
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Kein Nachname':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  'Stephan'
        lastName:   ''
        street1:    'Rennerstr. 11c'
        street2:    ''
        zip:        '4614'
        city:       'Machtrenk'
        email:      'meist@infoniqa.com'
        country:    'at'
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Keine Straße':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  'Stephan'
        lastName:   'Meißner'
        street1:    ''
        street2:    ''
        zip:        ''
        city:       'Machtrenk'
        email:      'meist@infoniqa.com'
        country:    'at'
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Keine PLZ':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  'Stephan'
        lastName:   'Meißner'
        street1:    'Rennerstr. 11c'
        street2:    ''
        zip:        ''
        city:       'Machtrenk'
        email:      'meist@infoniqa.com'
        country:    'at'
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Keine Stadt':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  'Stephan'
        lastName:   'Meißner'
        street1:    'Rennerstr. 11c'
        street2:    ''
        zip:        '4614'
        city:       ''
        email:      'meist@infoniqa.com'
        country:    'at'
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Kein Land':
      products:       []
      addresses: [
        salutation: 'Herr'
        firstName:  'Stephan'
        lastName:   'Meißner'
        street1:    'Rennerstr. 11c'
        street2:    ''
        zip:        '4614'
        city:       'Marchtrenk'
        email:      'meist@infoniqa.com'
        country:    ''
      ]
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
    'Keine Adresse':
      products:       []
      shippingCost:   5.40
      comment:        'Bitte mit Liebe verpacken *g*.'
