<?php

namespace Storelocator\Controller;

use Storelocator\Controller\LocalizedController;
use Zend\View\Model\ViewModel;

class StorelocatorController extends LocalizedController {

  public function indexAction() {    
    return new ViewModel(array(
        'lang' => $this->getLang(),
    ));
  }

  public function countryAction() {
    $request = $this->getRequest();

    if ($request->isGet()) {
      $_country_id = $this->params('id');

      return new ViewModel(array(
          'lang' => $this->getLang(),
          'country_id' => $_country_id ? $_country_id : 'none'
      ));
    }
  }

}