# Hablaba - Spanish Verb Conjugator

Hablaba conjugates regular Spanish verbs in multiple tenses.

Current tenses supported:

* present (I *speak* - *hablo*)
* preterite (I *spoke* - *hablé*)
* imperfect (I *used to speak* - *hablaba*)
* present_subjunctive (I hope *that I speak* - *hable*)
* imperfect_subjunctive (I hoped *that I spoke* - *hablara*)
* conditional (I *would speak* - *hablaría*)
* future (I *will speak* - *hablaré*)

## Usage

    Hablaba.conjugate("yo", "hablar")
    # => 'hablo'

    Hablaba.conjugate("yo", "hablar", :preterite)
    # => 'hablé'

Supported pronouns:

    yo tú él ella nosotros vosotros ellos ellas usted ustedes

Supported tenses:

    :present :preterite :imperfect :present_subjunctive :imperfect_subjunctive :conditional :future


