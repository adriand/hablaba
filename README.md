# Hablaba - Spanish Verb Conjugator

Hablaba conjugates regular Spanish verbs in multiple tenses.

Current tenses supported:

* present (I *speak* - *hablo*)
* preterite (I *spoke* - *hablé*)
* imperfect (I *used to speak* - *hablaba*)

Only the indicative mood is supported at the moment, but more moods (and tenses) are on the way.

## Usage

    Hablaba.conjugate("yo", "hablar")
    # => 'hablo'

    Hablaba.conjugate("yo", "hablar", :preterite)
    # => 'hablé'

Supported pronouns:

    yo tú él ella nosotros vosotros ellos ellas usted ustedes

Supported tenses:

    :present :preterite :imperfect


