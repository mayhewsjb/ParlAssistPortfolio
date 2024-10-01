import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    apiKey: String,
    ukCoordinates: Array,
    constituencyCoordinates: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    // Default center is the UK's center
    let center = this.ukCoordinatesValue || [-3.4, 54.7];

    // If constituency coordinates are available, use the first coordinate to center the map
    if (this.hasConstituencyCoordinatesValue && this.constituencyCoordinatesValue.length > 0) {
      const firstConstituencyCoordinate = this.constituencyCoordinatesValue[0];
      center = [firstConstituencyCoordinate[0], firstConstituencyCoordinate[1]];
    }

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v10',
      center: center,
      zoom: 7.6 // Adjust as necessary, maybe a closer zoom for a single constituency
    });

    this.#addConstituencyToMap();
  }


  #addConstituencyToMap() {
    if (this.hasConstituencyCoordinatesValue) {
      this.map.on('load', () => {
        // Assuming the constituency coordinates are for a polygon
        this.map.addSource('constituency', {
          type: 'geojson',
          data: {
            type: 'Feature',
            geometry: {
              type: 'Polygon',
              coordinates: [this.constituencyCoordinatesValue]
            }
          }
        });

        this.map.addLayer({
          id: 'constituency',
          type: 'fill',
          source: 'constituency',
          layout: {},
          paint: {
            'fill-color': '#088',
            'fill-opacity': 0.8
          }
        });
      });
    }
  }
  
}
