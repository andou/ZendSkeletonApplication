<?php

namespace Storelocator\Controller;

use Storelocator\Controller\LocalizedController;
use Zend\View\Model\ViewModel;

class StorelocatorController extends LocalizedController {

  public function indexAction() {

    return new ViewModel(array(
        'store_code' => $this->getStoreCode(),
    ));
  }

  public function countryAction() {
    $request = $this->getRequest();

    if ($request->isGet()) {
      $_country_id = $this->params('id');

      return new ViewModel(array(
          'store_code' => $this->getStoreCode(),
          'country_id' => $_country_id ? $_country_id : 'none'
      ));
    }
  }

}